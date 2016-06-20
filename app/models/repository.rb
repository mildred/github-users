# frozen_string_literal: true

class Repository < ActiveRecord::Base
  include Contracts::Core
  include Contracts::Builtin

  belongs_to :user

  Contract GithubRepository => Repository
  def self.create_or_update(github_repository)
    repo = find_or_create_by name: github_repository.name
    repo.update repo_created_at: github_repository.created_at
    repo
  end
end
