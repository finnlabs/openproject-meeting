class Meeting < ActiveRecord::Base
  unloadable

  self.table_name = 'meetings'

  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  has_one :agenda, :dependent => :destroy, :class_name => 'MeetingAgenda'
  has_one :minutes, :dependent => :destroy, :class_name => 'MeetingMinutes'
  has_many :contents, :class_name => 'MeetingContent', :readonly => true
  has_many :participants, :dependent => :destroy, :class_name => 'MeetingParticipant'

  scope :from_tomorrow, :conditions => ['start_time >= ?', Date.tomorrow.beginning_of_day]

  attr_accessible :title, :location, :start_time, :duration

  acts_as_watchable

  acts_as_searchable :columns => ["#{table_name}.title", "#{MeetingContent.table_name}.text"],
                     :include => [:contents, :project],
                     :date_column => "#{table_name}.created_at"

  acts_as_journalized :activity_find_options => {:include => [:agenda, :author, :project]},
                      :event_title => Proc.new {|o| "#{l :label_meeting}: #{o.title} (#{format_date o.start_time} #{format_time o.start_time, false}-#{format_time o.end_time, false})"},
                      :event_url => Proc.new {|o| {:controller => 'meetings', :action => 'show', :id => o.journaled}}

  register_on_journal_formatter(:plaintext, 'title')
  register_on_journal_formatter(:fraction, 'duration')
  register_on_journal_formatter(:datetime, 'start_time')
  register_on_journal_formatter(:plaintext, 'location')

  accepts_nested_attributes_for :participants, :reject_if => proc {|attrs| !(attrs['attended'] || attrs['invited'])}

  validates_presence_of :title, :start_time, :duration

  before_save :add_new_participants_as_watcher

  after_initialize :set_initial_values

  User.before_destroy do |user|
    Meeting.update_all ['author_id = ?', DeletedUser.first.id], ['author_id = ?', user.id]
  end

  def self.find_time_sorted(*args)
    options = args.extract_options!
    options[:order] = ["#{Meeting.table_name}.start_time DESC", options[:order]].compact.join(', ')
    args << options

    by_start_year_month_date = ActiveSupport::OrderedHash.new
    self.find(*args).group_by(&:start_year).each do |year,objs|
      by_start_year_month_date[year] = ActiveSupport::OrderedHash.new
      objs.group_by(&:start_month).each do |month,objs|
        by_start_year_month_date[year][month] = ActiveSupport::OrderedHash.new
        objs.group_by(&:start_date).each do |date,objs|
          by_start_year_month_date[year][month][date] = objs
        end
      end
    end
    by_start_year_month_date
  end

  def start_date
    # the text_field + calendar_for form helpers expect a Date
    start_time.to_date if start_time.present?
  end

  def start_month
    start_time.month
  end

  def start_year
    start_time.year
  end

  def end_time
    start_time + duration.hours
  end

  def to_s
    title
  end

  def text
    agenda.text if agenda.present?
  end

  def author=(user)
    super
    # Don't add the author as participant if we already have some through nested attributes
    self.participants.build(:user => user, :invited => true) if (self.new_record? && self.participants.empty? && user)
  end

   # Returns true if usr or current user is allowed to view the meeting
  def visible?(user=nil)
    (user || User.current).allowed_to?(:view_meetings, self.project)
  end

  def all_possible_participants
    self.project.users.all(:include => { :memberships => [:roles, :project] } ).select{ |u| self.visible?(u) }
  end

  def copy(attrs)
    copy = self.dup

    copy.author = attrs.delete(:author)
    copy.attributes = attrs
    copy.send(:set_initial_values)

    copy.participants.clear
    copy.participants << self.participants.collect(&:clone).each{|p| p.id = nil; p.attended = false} # Make sure the participants have no id

    copy
  end

  def close_agenda_and_copy_to_minutes!
    self.agenda.lock!
    self.create_minutes(:text => agenda.text)
  end

  protected

  def set_initial_values
    # set defaults
    self.start_time ||= Date.tomorrow + 10.hours
    self.duration   ||= 1
  end

  private

  def add_new_participants_as_watcher
    self.participants.select(&:new_record?).each do |p|
      add_watcher(p.user)
    end
  end
end
