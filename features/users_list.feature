Feature: As a visitor I want to show a list of all users found

  Une seconde page ('/users') qui affiche les users enregistrés (triés par ordre alphanumérique) avec leur nombre de repos.

  Scenario: A message is displayed if no users are found
    Given there is no users
    When I am on the users page
    Then an error "There is no user to display." is displayed

  Scenario: Display list of all users with name and repository count
    Given there is some users
    When I am on the users page
    Then I see a list of all users

  Scenario: List of users are ordered by name
    Given there is some users
    When I am on the users page
    Then the list is ordered by name
