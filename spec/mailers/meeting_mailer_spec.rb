require "spec_helper"
include Redmine::I18n

describe MeetingMailer do
  before(:each) do
    @role = FactoryGirl.create(:role, :permissions => [:view_meetings])
    @content = FactoryGirl.create(:meeting_agenda)
    @author = @content.meeting.author
    @project = @content.meeting.project
    @watcher1 = FactoryGirl.create(:user)
    @watcher2 = FactoryGirl.create(:user)
    @project.add_member @author, [@role]
    @project.add_member @watcher1, [@role]
    @project.add_member @watcher2, [@role]

    @participants = [@content.meeting.participants.build(:user => @watcher1, :invited => true, :attended => false),
                     @content.meeting.participants.build(:user => @watcher2, :invited => true, :attended => false)]

    @project.save!
    @content.meeting.save!

    @content.meeting.watcher_users true
  end

  describe "content_for_review" do
    let(:mail) { MeetingMailer.content_for_review @content, 'agenda' }

    it "renders the headers" do
      mail.subject.should include(@content.meeting.project.name)
      mail.subject.should include(@content.meeting.title)
      mail.to.should include(@author.mail)
      mail.from.should eq([Setting.mail_from])
      mail.cc.should_not include(@author.mail)
      mail.cc.should include(@watcher1.mail)
      mail.cc.should include(@watcher2.mail)
    end

    it "renders the text body" do
      check_meeting_mail_content mail.text_part.body
    end

    it "renders the html body" do
      check_meeting_mail_content mail.html_part.body
    end
  end

  def check_meeting_mail_content(body)
      body.should include(@content.meeting.project.name)
      body.should include(@content.meeting.title)
      body.should include(format_date @content.meeting.start_date)
      body.should include(format_time @content.meeting.start_time, false)
      body.should include(format_time @content.meeting.end_time, false)
      body.should include(@participants[0].name)
      body.should include(@participants[1].name)
  end

  def save_and_open_mail_html_body(mail)
    save_and_open_mail_part mail.html_part.body
  end

  def save_and_open_mail_text_body(mail)
    save_and_open_mail_part mail.text_part.body
  end

  def save_and_open_mail_part(part)
    FileUtils.mkdir_p(Rails.root.join('tmp/mails'))

    page_path = Rails.root.join("tmp/mails/#{SecureRandom.hex(16)}.html").to_s
    File.open(page_path, 'w') { |f| f.write(part) }

    Launchy.open(page_path)

    begin
      binding.pry
    rescue NoMethodError
      debugger
    end

    FileUtils.rm(page_path)

  end
end
