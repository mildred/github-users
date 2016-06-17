# frozen_string_literal: true

class User < ActiveRecord::Base
  include Contracts::Core
  include Contracts::Builtin

  has_many :repositories

  Contract GithubUser => User
  def self.create_or_update(github_user)
    user = find_or_create_by login: github_user.login
    user.update name: github_user.name,
                repositories: github_user.repositories.map { |repo| Repository.create_or_update repo }
    user
  end
end
