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

  Contract RespondTo[:name, :updated_at, :pushed_at] => Repository
  def self.from(repository)
    updated_at = most_recent_date repository.updated_at, repository.pushed_at
    Repository.new name: repository.name, updated_at: updated_at
  end

  Contract Maybe[Time], Maybe[Time] => Time
  def self.most_recent_date(date1, date2)
    if date1.nil?
      date2
    elsif date2.nil?
      date1
    else
      [date1, date2].max
    end
  end
end
