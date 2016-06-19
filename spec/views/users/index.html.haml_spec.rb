# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index.html.haml' do
  before do
    FactoryGirl.create_list(:user_with_repositories, Faker::Number.between(10, 30))
  end
  let(:user_list_presenter) { UserListPresenter.new User.all }

  it 'should display the list of all users' do
    assign(:users, user_list_presenter)
    render

    user_list_presenter.each do |user|
      expect(rendered).to have_selector '.user' do |el|
        expect(el).to contain user.name
        expect(el).to contain "#{user.repositories.count} repositories"
      end
    end
  end
end
