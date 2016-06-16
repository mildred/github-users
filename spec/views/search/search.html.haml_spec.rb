# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'search/search.html.haml' do
  context 'Given a github user' do
    let(:user) { { name: Faker::Superhero.name } }

    it 'should display the name of the user' do
      assign(:user, user)
      render

      expect(rendered).to have_selector 'h1', text: user[:name]
    end
  end
end
