# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET search' do
    context 'when user is not found' do
      let(:name) { 'an invalid github username' }
      before { allow(Octokit).to receive(:user).with(name).and_raise Octokit::NotFound }

      it 'should redirect to the root path' do
        get :search, name: name
        expect(response).to redirect_to(root_path)
      end

      it 'should display an error message' do
        get :search, name: name
        expect(flash[:alert]).to eq "'#{name}' is not a valid github username."
      end
    end

    context 'when user is found' do
      let(:user_name) { Faker::Superhero.name }
      let(:name) { 'eunomie' }
      let(:repositories) do
        [
          GithubRepository.new(name: Faker::Superhero.name,
                               updated_at: Faker::Time.between(10.days.ago, Time.zone.today)),
          GithubRepository.new(name: Faker::Superhero.name,
                               updated_at: Faker::Time.between(10.days.ago, Time.zone.today))
        ]
      end
      let(:octokit_user) { Sawyer::Resource.new(Octokit.agent, login: name, name: user_name) }
      let(:octokit_repos) do
        repositories.map do |repo|
          Sawyer::Resource.new(Octokit.agent, name: repo.name, updated_at: repo.updated_at, pushed_at: nil)
        end
      end
      before { allow(Octokit).to receive(:user).with(name).and_return(octokit_user) }
      before { allow(Octokit).to receive(:repositories).with(name).and_return(octokit_repos) }

      it 'should render the search template' do
        get :search, name: name
        expect(response).to render_template(:search)
      end

      it 'should not display an error message' do
        get :search, name: name
        expect(flash[:alert]).to be_nil
      end
    end
  end
end
