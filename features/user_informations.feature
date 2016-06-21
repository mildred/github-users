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
    Then an error "is not a valid github user" is displayed

  Scenario Outline: Display name of found user
    Given I am on the root page
    When I search an existing github "<username>"
    Then I can show the "<name>" of the user
    Examples:
    |username|name|
    |eunomie|Yves Brissaud|
    |defunkt|Chris Wanstrath|

  Scenario Outline: Display repositories of the user
    Given I am on the root page
    When I search an existing github "<username>"
    Then I display a list of github repositories for the user "<username>"
    Examples:
    |username|
    |eunomie|
    |defunkt|

  Scenario Outline: Display date of repositories
    Given I am on the root page
    When I search an existing github "<username>"
    Then I display the creation date for repositories of user "<username>"
    Examples:
    |username|
    |eunomie|
    |defunkt|

  Scenario Outline: Order repositories by date
    Given I am on the root page
    When I search an existing github "<username>"
    Then repositories are ordered by date
    Examples:
    |username|
    |eunomie|
    |defunkt|

  Scenario: User has no repository
    Given I am on the root page
    When I search an existing github user without repository
    Then the repository list is empty
    And a message "The user has no repository" is displayed

  Scenario Outline: Save user
    Given I am on the root page
    When I search an existing github "<username>"
    Then I store the user with repositories in database
    Examples:
    |username|
    |eunomie|
    |defunkt|

  Scenario Outline: Update user
    Given I am on the root page
    And A user is saved with "<username>"
    When I search an existing github "<username>"
    Then I update the user
    Examples:
    |username|
    |eunomie|
    |defunkt|

  Scenario Outline: Store followers
    Given I am on the root page
    When I search an existing github "<username>"
    Then I store the number of stars for all repositories of the user identified by "<username>"
    Examples:
    |username|
    |eunomie|
    |defunkt|
