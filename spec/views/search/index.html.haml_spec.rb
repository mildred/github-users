# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'search/index.html.haml' do
  it 'should display a form with a name field' do
    render

    expect(rendered).to have_css('form')
    expect(rendered).to have_css('form input[type=text][name=name]')
  end
end
