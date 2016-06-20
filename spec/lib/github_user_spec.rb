# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubUser do
  let(:login) { Faker::Superhero.name }
  let(:name) { Faker::Superhero.name }
  let(:stars) { Faker::Number.number(3).to_i }
  let(:repositories) do
    [
      GithubRepository.new(name: Faker::Superhero.name,
                           stars: Faker::Number.between(0, 100),
                           updated_at: Faker::Time.between(10.days.ago, Time.zone.today)),
      GithubRepository.new(name: Faker::Superhero.name,
                           stars: Faker::Number.between(0, 100),
                           updated_at: Faker::Time.between(10.days.ago, Time.zone.today))
    ]
  end

  describe '::new' do
    it 'should store login, name, stars and repositories' do
      user = GithubUser.new(login: login,
                            name: name,
                            repositories: repositories)
      expect(user.login).to eq login
      expect(user.name).to eq name
      expect(user.stars).to eq repositories.map(&:stars).inject(0, &:+)
      expect(user.repositories).to eq repositories
    end

    it 'should not accept other than string for login' do
      expect do
        GithubUser.new login: 2, name: name, repositories: repositories
      end.to raise_error ContractError
      expect do
        GithubUser.new login: nil, name: name, repositories: repositories
      end.to raise_error ContractError
      expect do
        GithubUser.new login: [], name: name, repositories: repositories
      end.to raise_error ContractError
      expect do
        GithubUser.new login: true, name: name, repositories: repositories
      end.to raise_error ContractError
      expect do
        GithubUser.new login: {}, name: name, repositories: repositories
      end.to raise_error ContractError
    end

    it 'should not accept other than string for name' do
      expect do
        GithubUser.new login: login, name: 2, repositories: repositories
      end.to raise_error ContractError
      expect do
        GithubUser.new login: login, name: nil, repositories: repositories
      end.to raise_error ContractError
      expect do
        GithubUser.new login: login, name: [], repositories: repositories
      end.to raise_error ContractError
      expect do
        GithubUser.new login: login, name: true, repositories: repositories
      end.to raise_error ContractError
      expect do
        GithubUser.new login: login, name: {}, repositories: repositories
      end.to raise_error ContractError
    end

    it 'should accept empty array for repositories' do
      expect do
        GithubUser.new login: login, name: name, repositories: []
      end.not_to raise_error
    end

    it 'should not accept other than array of repository for repositories' do
      expect do
        GithubUser.new login: login, name: name, repositories: 'plop'
      end.to raise_error ContractError
      expect do
        GithubUser.new login: login, name: name, repositories: 2
      end.to raise_error ContractError
      expect do
        GithubUser.new login: login, name: name, repositories: nil
      end.to raise_error ContractError
      expect do
        GithubUser.new login: login, name: name, repositories: true
      end.to raise_error ContractError
      expect do
        GithubUser.new login: login, name: name, repositories: {}
      end.to raise_error ContractError
      expect do
        GithubUser.new login: login, name: name, repositories: [2, 'plop']
      end.to raise_error ContractError
    end
  end

  describe '::from' do
    let(:octokit_user) { Sawyer::Resource.new(Octokit.agent, login: login, name: name) }
    before do
      allow(GithubUser).to receive(:new).with(login: login,
                                              name: name,
                                              repositories: repositories).and_call_original
    end

    it 'should create a new user with login, name and repositories' do
      expect(GithubUser.from(octokit_user, with_repositories: repositories)).to be_a GithubUser
      expect(GithubUser).to have_received(:new).with(login: login,
                                                     name: name,
                                                     repositories: repositories)
    end
  end

  describe '#==' do
    it 'should return true if two objects have the same login, name and repositories' do
      user1 = GithubUser.new login: login, name: name, repositories: repositories
      user2 = GithubUser.new login: login, name: name, repositories: repositories
      expect(user1 == user2).to be true
    end

    it 'should return false if two objects have different login' do
      user1 = GithubUser.new login: login, name: name, repositories: repositories
      user2 = GithubUser.new login: Faker::Superhero.name,
                             name: name,
                             repositories: repositories
      expect(user1 == user2).to be false
    end

    it 'should return false if two objects have different name' do
      user1 = GithubUser.new login: login, name: name, repositories: repositories
      user2 = GithubUser.new login: login,
                             name: Faker::Superhero.name,
                             repositories: repositories
      expect(user1 == user2).to be false
    end

    it 'should return false if two objects have different stars' do
      user1 = GithubUser.new login: login, name: name, repositories: repositories
      repo = repositories.map do |r|
        GithubRepository.new(name: r.name,
                             stars: r.stars + 1,
                             updated_at: r.updated_at)
      end
      user2 = GithubUser.new login: login,
                             name: name,
                             repositories: repo
      expect(user1 == user2).to be false
    end

    it 'should return false if two objects have different repositories' do
      user1 = GithubUser.new login: login, name: name, repositories: repositories
      other_repos = [
        GithubRepository.new(name: Faker::Superhero.name,
                             stars: Faker::Number.between(0, 100),
                             updated_at: Faker::Time.between(10.days.ago, Time.zone.today))
      ]

      user2 = GithubUser.new login: login, name: name, repositories: other_repos
      expect(user1 == user2).to be false
    end
  end
end
