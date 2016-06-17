# frozen_string_literal: true

class UserCreator
  include Contracts::Core
  include Contracts::Builtin

  Contract RespondTo[:user_found, :user_not_found] => UserCreator
  def initialize(listener)
    @listener = listener
    self
  end

  Contract(GithubUser => Any)
  def user_found(github_user)
    User.create_or_update github_user

    @listener.user_found github_user
  end

  Contract InvalidGithubUser => Any
  def user_not_found(error)
    @listener.user_not_found error
  end
end
