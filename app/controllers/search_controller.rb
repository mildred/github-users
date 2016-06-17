# frozen_string_literal: true

# Search a github user and display repositories informations
class SearchController < ApplicationController
  include Contracts::Core
  include Contracts::Builtin

  # GET /search
  def search
    finder = UserFinder.new(self)
    finder.find_by_name params[:name]
  end

  Contract(GithubUser => Any)
  def user_found(user)
    @user = UserPresenter.new user
    render :search
  end

  Contract InvalidGithubUser => Any
  def user_not_found(error)
    redirect_to root_path, alert: error.message
  end
end
