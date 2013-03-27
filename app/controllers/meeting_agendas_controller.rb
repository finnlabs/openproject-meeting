class MeetingAgendasController < MeetingContentsController
  unloadable

  menu_item :meetings

  def close
    @meeting.close_agenda_and_copy_to_minutes!

    redirect_back_or_default :controller => 'meetings', :action => 'show', :id => @meeting
  end

  def open
    @content.unlock!
    redirect_back_or_default :controller => 'meetings', :action => 'show', :id => @meeting
  end

  private

  def find_content
    @content = @meeting.agenda || @meeting.build_agenda
    @content_type = "meeting_agenda"
  end
end
