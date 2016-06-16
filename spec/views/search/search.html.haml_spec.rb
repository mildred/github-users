# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'search/search.html.haml' do
  context 'Given a github user' do
    let(:repositories) do
      [
        Repository.new(name: Faker::Superhero.name,
                       updated_at: Faker::Time.between(10.days.ago, Time.zone.today)),
        Repository.new(name: Faker::Superhero.name,
                       updated_at: Faker::Time.between(10.days.ago, Time.zone.today))
      ]
    end
    let(:user) do
      User.new(name: Faker::Superhero.name, login: Faker::Superhero.name, repositories: repositories)
    end

    it 'should display the name of the user' do
      assign(:user, user)
      render

      expect(rendered).to have_selector 'h1', text: user.name
    end

    it 'should display the list of repositories' do
      assign(:user, user)
      render

      repositories.each do |repo|
        expect(rendered).to have_selector 'ul li', text: repo.name
      end
    end
  end
end
