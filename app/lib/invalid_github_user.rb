# frozen_string_literal: true

class InvalidGithubUser
  include Contracts::Core
  include Contracts::Builtin

  Contract String => InvalidGithubUser
  def initialize(name)
    @name = name
    self
  end

  Contract None => String
  def message
    "'#{@name}' is not a valid github username."
  end
end
