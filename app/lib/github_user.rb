# frozen_string_literal: true

class GithubUser
  include Contracts::Core
  include Contracts::Builtin

  attr_reader :login, :name, :followers, :repositories

  Contract KeywordArgs[login: String,
                       name: String,
                       followers: Num,
                       repositories: ArrayOf[GithubRepository]] => GithubUser
  def initialize(login:, name:, followers:, repositories:)
    @login = login
    @name = name
    @followers = followers
    @repositories = repositories
    self
  end

  Contract GithubUser => Bool
  def ==(other)
    login == other.login &&
      name == other.name &&
      repositories == other.repositories
  end

  Contract RespondTo[:login, :name, :followers],
           KeywordArgs[with_repositories: ArrayOf[GithubRepository]] => GithubUser
  def self.from(user, with_repositories:)
    GithubUser.new login: user.login,
                   name: user.name,
                   followers: user.followers,
                   repositories: with_repositories
  end
end
