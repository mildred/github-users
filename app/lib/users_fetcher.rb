# frozen_string_literal: true

class UsersFetcher
  include Contracts::Core
  include Contracts::Builtin

  Contract RespondTo[:users_found, :users_not_found] =>
    UsersFetcher
  def initialize(listener)
    @listener = listener
    self
  end

  Contract None => nil
  def fetch_users
    users = User.all
    if users.empty?
      @listener.users_not_found EmptyUserList.instance
    else
      @listener.users_found users
    end
    nil
  end
end
