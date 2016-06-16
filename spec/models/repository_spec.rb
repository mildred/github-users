# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository do
  let(:name) { Faker::App.name }
  let(:updated_at) { Faker::Time.between(2.days.ago, Time.zone.today) }

  describe '::new' do
    it 'should store name and date' do
      repo = Repository.new name: name, updated_at: updated_at
      expect(repo.name).to eq name
      expect(repo.updated_at).to eq updated_at
    end

    it 'should not accept other than string for name' do
      expect { Repository.new name: 2, updated_at: updated_at }.to raise_error ContractError
      expect { Repository.new name: [], updated_at: updated_at }.to raise_error ContractError
      expect { Repository.new name: {}, updated_at: updated_at }.to raise_error ContractError
      expect { Repository.new name: nil, updated_at: updated_at }.to raise_error ContractError
      expect { Repository.new name: true, updated_at: updated_at }.to raise_error ContractError
    end

    it 'should not accept other than date for updated_at' do
      expect { Repository.new name: name, updated_at: 'plop' }.to raise_error ContractError
      expect { Repository.new name: name, updated_at: 3 }.to raise_error ContractError
      expect { Repository.new name: name, updated_at: nil }.to raise_error ContractError
      expect { Repository.new name: name, updated_at: [] }.to raise_error ContractError
      expect { Repository.new name: name, updated_at: {} }.to raise_error ContractError
      expect { Repository.new name: name, updated_at: true }.to raise_error ContractError
    end
  end

  describe '::from' do
    let(:octokit_repo) { Sawyer::Resource.new(Octokit.agent, name: name, updated_at: updated_at) }
    before { allow(Repository).to receive(:new).with(name: name, updated_at: updated_at).and_call_original }

    it 'should create a new repository with name and date' do
      expect(Repository.from(octokit_repo)).to be_a Repository
      expect(Repository).to have_received(:new).with(name: name, updated_at: updated_at)
    end
  end

  describe '#==' do
    it 'should return true if two objects have the same values' do
      repo1 = Repository.new name: name, updated_at: updated_at
      repo2 = Repository.new name: name, updated_at: updated_at
      expect(repo1 == repo2).to be true
    end

    it 'should return false if two objects have different name' do
      repo1 = Repository.new name: name, updated_at: updated_at
      repo2 = Repository.new name: Faker::Superhero.name, updated_at: updated_at
      expect(repo1 == repo2).to be false
    end

    it 'should return false if two objects have different date' do
      repo1 = Repository.new name: name, updated_at: updated_at
      repo2 = Repository.new name: name, updated_at: Faker::Time.between(2.days.ago, Time.zone.today)
      expect(repo1 == repo2).to be false
    end
  end
end
