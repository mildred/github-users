# frozen_string_literal: true

class UserPresenter < SimpleDelegator
  include Contracts::Core
  include Contracts::Builtin

  delegate :name, to: :user

  Contract User => UserPresenter
  def initialize(user)
    super user
    self
  end

  Contract None => User
  def user
    __getobj__
  end

  Contract None => ArrayOf[Repository]
  def repositories
    user.repositories.sort { |repo1, repo2| repo2.updated_at <=> repo1.updated_at }
  end
end
