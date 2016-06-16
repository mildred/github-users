# frozen_string_literal: true

class Repository
  include Contracts::Core
  include Contracts::Builtin

  attr_reader :name, :updated_at

  Contract KeywordArgs[name: String, updated_at: Time] => Repository
  def initialize(name:, updated_at:)
    @name = name
    @updated_at = updated_at
    self
  end

  Contract Repository => Bool
  def ==(other)
    name == other.name &&
      updated_at == other.updated_at
  end

  Contract RespondTo[:name, :updated_at] => Repository
  def self.from(repository)
    Repository.new name: repository.name, updated_at: repository.updated_at
  end
end
