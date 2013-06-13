Feature: Meeting has participants

  Background:
    Given there is 1 project with the following:
          | identifier | dingens |
          | name       | dingens |
      And the project "dingens" uses the following modules:
          | meetings |
      And there is 1 user with:
          | login     | alice |
          | firstname | Alice |
          | lastname  | Alice |
          | language  | en    |
      And there is 1 user with:
          | login     | bob    |
          | firstname | Bob    |
          | lastname  | Bobbit |
          | language  | en     |
      And there is a role "meeting_viewer"
      And there is a role "meeting_editor"
      And the role "meeting_viewer" may have the following rights:
          | view_meetings |
      And the role "meeting_editor" may have the following rights:
          | view_meetings |
          | edit_meetings |
      And the user "bob" is a "meeting_editor" in the project "dingens"
      And there is 1 meeting in project "dingens" created by "bob" with:
          | title | Bobs Meeting |
    Given I am already logged in as "bob"

  Scenario: Users not allowed to view meetings are no valid participants
     When I go to the edit page of the meeting called "Bobs Meeting"
     Then the user "alice" should not be available as a participant

  Scenario: Users allowed to view meetings are valid participants
    Given the user "alice" is a "meeting_viewer" in the project "dingens"
     When I go to the edit page of the meeting called "Bobs Meeting"
     Then the user "alice" should be available as a participant
