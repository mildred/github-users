# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:login) { Faker::Superhero.name }
  let(:name) { Faker::Superhero.name }

  describe '::new' do
    it 'should store login and name' do
      user = User.new login: login, name: name
      expect(user.login).to eq login
      expect(user.name).to eq name
    end

    it 'should set an empty list of repository' do
      user = User.new login: Faker::Superhero.name, name: Faker::Superhero.name
      expect(user.repositories).to be_empty
    end

    it 'should not accept other than string for login' do
      expect { User.new login: 2, name: name }.to raise_error ContractError
      expect { User.new login: nil, name: name }.to raise_error ContractError
      expect { User.new login: [], name: name }.to raise_error ContractError
      expect { User.new login: true, name: name }.to raise_error ContractError
      expect { User.new login: {}, name: name }.to raise_error ContractError
    end

    it 'should not accept other than string for name' do
      expect { User.new login: login, name: 2 }.to raise_error ContractError
      expect { User.new login: login, name: nil }.to raise_error ContractError
      expect { User.new login: login, name: [] }.to raise_error ContractError
      expect { User.new login: login, name: true }.to raise_error ContractError
      expect { User.new login: login, name: {} }.to raise_error ContractError
    end
  end

  describe '::from' do
    let(:octokit_user) { Sawyer::Resource.new(Octokit.agent, login: login, name: name) }
    before { allow(User).to receive(:new).with(login: login, name: name).and_call_original }

    it 'should create a new user with login and name' do
      expect(User.from(octokit_user)).to be_a User
      expect(User).to have_received(:new).with(login: login, name: name)
    end
  end

  describe '#==' do
    it 'should return true if two objects have the same login, name' do
      user1 = User.new login: login, name: name
      user2 = User.new login: login, name: name
      expect(user1 == user2).to be true
    end

    it 'should return false if two objects have different login' do
      user1 = User.new login: login, name: name
      user2 = User.new login: Faker::Superhero.name, name: name
      expect(user1 == user2).to be false
    end

    it 'should return false if two objects have different name' do
      user1 = User.new login: login, name: name
      user2 = User.new login: name, name: Faker::Superhero.name
      expect(user1 == user2).to be false
    end
  end
end
