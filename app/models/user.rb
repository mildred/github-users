# frozen_string_literal: true

class User
  include Contracts::Core
  include Contracts::Builtin

  attr_reader :login, :name, :repositories

  Contract KeywordArgs[login: String, name: String] => User
  def initialize(login:, name:)
    @login = login
    @name = name
    @repositories = []
    self
  end

  Contract User => Bool
  def ==(other)
    login == other.login &&
      name == other.name &&
      repositories == other.repositories
  end

  Contract RespondTo[:login, :name] => User
  def self.from(user)
    User.new login: user.login, name: user.name
  end
end
