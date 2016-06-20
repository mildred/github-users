# frozen_string_literal: true

class GithubRepository
  include Contracts::Core
  include Contracts::Builtin

  attr_reader :name, :created_at, :stars

  Contract KeywordArgs[name: String, created_at: Time, stars: Num] => GithubRepository
  def initialize(name:, stars:, created_at:)
    @name = name
    @stars = stars
    @created_at = created_at
    self
  end

  Contract GithubRepository => Bool
  def ==(other)
    name == other.name &&
      stars == other.stars &&
      created_at == other.created_at
  end

  Contract RespondTo[:name, :stargazers_count, :created_at] => GithubRepository
  def self.from(repository)
    GithubRepository.new(name: repository.name,
                         stars: repository.stargazers_count,
                         created_at: repository.created_at)
  end
end
