# frozen_string_literal: true

class EmptyUserList
  include Contracts::Core
  include Contracts::Builtin

  include Singleton

  attr_reader :message

  Contract None => EmptyUserList
  def initialize
    @message = 'There is no user to display.'
    self
  end
end
