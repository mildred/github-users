# frozen_string_literal: true

class GithubUser
  include Contracts::Core
  include Contracts::Builtin

  attr_reader :login, :name, :repositories

  Contract KeywordArgs[login: String, name: String, repositories: ArrayOf[Repository]] => GithubUser
  def initialize(login:, name:, repositories:)
    @login = login
    @name = name
    @repositories = repositories
    self
  end

  Contract GithubUser => Bool
  def ==(other)
    login == other.login &&
      name == other.name &&
      repositories == other.repositories
  end

  Contract RespondTo[:login, :name], KeywordArgs[with_repositories: ArrayOf[Repository]] => GithubUser
  def self.from(user, with_repositories:)
    GithubUser.new login: user.login, name: user.name, repositories: with_repositories
  end
end
