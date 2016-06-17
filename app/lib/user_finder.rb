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

  Contract String => GithubUser
  def find_user(name)
    octokit_user = Octokit.user name
    octokit_repos = Octokit.repositories name
    repos = octokit_repos.map { |repo| Repository.from repo }
    GithubUser.from octokit_user, with_repositories: repos
  end
end
