# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:login) { Faker::Superhero.name }
  let(:name) { Faker::Superhero.name }
  let(:repositories) do
    [
      Repository.new(name: Faker::Superhero.name,
                     updated_at: Faker::Time.between(10.days.ago, Time.zone.today)),
      Repository.new(name: Faker::Superhero.name,
                     updated_at: Faker::Time.between(10.days.ago, Time.zone.today))
    ]
  end

  describe '::new' do
    it 'should store login, name and repositories' do
      user = User.new login: login, name: name, repositories: repositories
      expect(user.login).to eq login
      expect(user.name).to eq name
      expect(user.repositories).to eq repositories
    end

    it 'should not accept other than string for login' do
      expect { User.new login: 2, name: name, repositories: repositories }.to raise_error ContractError
      expect { User.new login: nil, name: name, repositories: repositories }.to raise_error ContractError
      expect { User.new login: [], name: name, repositories: repositories }.to raise_error ContractError
      expect { User.new login: true, name: name, repositories: repositories }.to raise_error ContractError
      expect { User.new login: {}, name: name, repositories: repositories }.to raise_error ContractError
    end

    it 'should not accept other than string for name' do
      expect { User.new login: login, name: 2, repositories: repositories }.to raise_error ContractError
      expect { User.new login: login, name: nil, repositories: repositories }.to raise_error ContractError
      expect { User.new login: login, name: [], repositories: repositories }.to raise_error ContractError
      expect { User.new login: login, name: true, repositories: repositories }.to raise_error ContractError
      expect { User.new login: login, name: {}, repositories: repositories }.to raise_error ContractError
    end

    it 'should accept empty array for repositories' do
      expect { User.new login: login, name: name, repositories: [] }.not_to raise_error ContractError
    end

    it 'should not accept other than array of repositoru for repositories' do
      expect { User.new login: login, name: name, repositories: 'plop' }.to raise_error ContractError
      expect { User.new login: login, name: name, repositories: 2 }.to raise_error ContractError
      expect { User.new login: login, name: name, repositories: nil }.to raise_error ContractError
      expect { User.new login: login, name: name, repositories: true }.to raise_error ContractError
      expect { User.new login: login, name: name, repositories: {} }.to raise_error ContractError
      expect { User.new login: login, name: name, repositories: [2, 'plop'] }.to raise_error ContractError
    end
  end

  describe '::from' do
    let(:octokit_user) { Sawyer::Resource.new(Octokit.agent, login: login, name: name) }
    before do
      allow(User).to receive(:new).with(login: login,
                                        name: name,
                                        repositories: repositories).and_call_original
    end

    it 'should create a new user with login, name and repositories' do
      expect(User.from(octokit_user, with_repositories: repositories)).to be_a User
      expect(User).to have_received(:new).with(login: login, name: name, repositories: repositories)
    end
  end

  describe '#==' do
    it 'should return true if two objects have the same login, name and repositories' do
      user1 = User.new login: login, name: name, repositories: repositories
      user2 = User.new login: login, name: name, repositories: repositories
      expect(user1 == user2).to be true
    end

    it 'should return false if two objects have different login' do
      user1 = User.new login: login, name: name, repositories: repositories
      user2 = User.new login: Faker::Superhero.name, name: name, repositories: repositories
      expect(user1 == user2).to be false
    end

    it 'should return false if two objects have different name' do
      user1 = User.new login: login, name: name, repositories: repositories
      user2 = User.new login: login, name: Faker::Superhero.name, repositories: repositories
      expect(user1 == user2).to be false
    end

    it 'should return false if two objects have different repositories' do
      user1 = User.new login: login, name: name, repositories: repositories
      other_repos = [
        Repository.new(name: Faker::Superhero.name,
                       updated_at: Faker::Time.between(10.days.ago, Time.zone.today))
      ]

      user2 = User.new login: login, name: name, repositories: other_repos
      expect(user1 == user2).to be false
    end
  end
end
