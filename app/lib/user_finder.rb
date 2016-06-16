# frozen_string_literal: true

class UserFinder
  include Contracts::Core
  include Contracts::Builtin

  Contract RespondTo[:user_found, :user_not_found] =>
    UserFinder
  def initialize(listener)
    @listener = listener
    self
  end

  Contract String => nil
  def find_by_name(name)
    begin
      user = find_user name
      @listener.user_found user
    rescue Octokit::NotFound
      @listener.user_not_found InvalidGithubUser.new(name)
    end
    nil
  end

  private

  Contract String => User
  def find_user(name)
    user = Octokit.user name
    User.from user
  end
end
