# frozen_string_literal: true

# Display users from database
class UsersController < ApplicationController
  include Contracts::Core
  include Contracts::Builtin

  # GET /index
  def index
    fetcher = UsersFetcher.new(self)
    fetcher.fetch_users
  end

  Contract User::ActiveRecord_Relation => Any
  def users_found(users)
    @users = UserListPresenter.new users
    render :index
  end

  Contract EmptyUserList => Any
  def users_not_found(error)
    flash[:alert] = error.message
    render :index
  end
end
