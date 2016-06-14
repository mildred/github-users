Feature: As a visitor I want to show informations about a github user

  Une page root ('/') avec un formulaire pour entrer le nom d'un user github (exemple: lkdjiin, defunkt). Suite à la soumission du formulaire :

  - on affiche tous les noms de repos du user avec leur date, triés par date.
  - on enregistre les informations suivantes : nom et nombre de stars du user dans la table user, nom et date des repos dans la table repository.

  Scenario: A form to enter a github name is available on the root page
    Given I am on the root page
    Then I have a form to enter a github name

  Scenario: An error is displayed when I search an unexisting user
    Given I am on the root page
    When I search an unexisting github user
    Then an error "This is not a valid github user" is displayed

  Scenario: Display repositories of the user
    Given I am on the root page
    When I search an existing github user
    Then I display a list of all github repositories

  Scenario: Display date of repositories
    Given I am on the root page
    When I search an existing github user
    Then I display a date for all repositories

  Scenario: Order repositories by date
    Given I am on the root page
    When I search an existing github user
    Then I order repositories by date

  Scenario: User has no repository
    Given I am on the root page
    When I search an existing github user without repository
    Then the repository list is empty
    And a message "The user has no repository" is displayed
