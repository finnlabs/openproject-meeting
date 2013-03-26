Feature: Show meeting activity

  Background:
        Given there is 1 project with the following:
              | identifier | dingens |
              | name       | dingens |
          And the project "dingens" uses the following modules:
              | meetings |
              | activity |
          And there is 1 user with:
              | login    | alice |
              | language | en    |
              | admin    | true  |
          And there is a role "user"
          And the role "user" may have the following rights:
              | view_meetings |
              | edit_meetings |
          And the user "alice" is a "user" in the project "dingens"
          And the user "alice" has the following preferences
              | time_zone | UTC |
          And there is 1 user with:
              | login    | bob |
          And there is 1 meeting in project "dingens" created by "bob" with:
              | title      | Bobs Meeting        |
              | location   | Room 2              |
              | duration   | 2.5                 |
              | start_time | 2011-02-10 11:00:00 |
          And the meeting "Bobs Meeting" has 1 agenda with:
              | locked | true   |
              | text   | foobaz |
          And the meeting "Bobs Meeting" has minutes with:
              | text   | barbaz |

  Scenario: Navigate to the project's activity page and see the meeting activity
       When I am already logged in as "alice"
        And I go to the meetings activity page for the project "dingens"
       Then I should see "Meeting: Bobs Meeting (02/10/2011 11:00 am-01:30 pm)" within "dt.meeting > a"
        And I should see "Agenda: Bobs Meeting" within ".meeting-agenda"
        And I should see "Minutes: Bobs Meeting" within ".meeting-minutes"

  Scenario: Change a metadata on a meeting and see the activity on the project's activity page
       When I am already logged in as "alice"
        And I go to the meetings page for the project called "dingens"
        And I click on "Bobs Meeting"
        And I click on "Edit"
        And I fill in the following:
            | meeting_location | Geheimer Ort! |
        And I click on "Save"
        And I go to the meetings activity page for the project "dingens"
       Then I should see "Meeting: Bobs Meeting (02/10/2011 11:00 am-01:30 pm)" within ".meeting.me"
