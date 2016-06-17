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
    Then I display a list of github "<repositories>"
    Examples:
    |username|repositories|
    |eunomie|12factor,action_cable_demo,angular-phonecat,angular.js,asentaa|

  Scenario Outline: Display date of repositories
    Given I am on the root page
    When I search an existing github "<username>"
    Then I display a date for github "<repositories>"
    Examples:
    |username|repositories|
    |eunomie|12factor!2015-05-26 13:03:28 UTC,action_cable_demo!2016-01-21 21:47:25 UTC,angular-phonecat!2013-06-18 07:31:48 UTC,angular.js!2014-01-15 20:51:04 UTC,asentaa!2013-12-10 14:40:09 UTC|

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
