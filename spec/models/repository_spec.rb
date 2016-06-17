# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository do
  let(:name) { Faker::App.name }
  let(:updated_at) { Faker::Time.between(3.weeks.ago, Time.zone.today) }
  let(:pushed_at) { Faker::Time.between(updated_at, Time.zone.today) }

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

  describe '::most_recent_date' do
    let(:date) { Faker::Time.between(2.days.ago, Time.zone.today) }
    let(:date_before) { Faker::Time.between(3.days.ago(date), 1.days.ago(date)) }

    it 'should return the most recent date' do
      expect(Repository.most_recent_date(date, date_before)).to eq date
      expect(Repository.most_recent_date(date_before, date)).to eq date
    end

    it 'should return the non nil date if one is nil' do
      expect(Repository.most_recent_date(date, nil)).to eq date
      expect(Repository.most_recent_date(nil, date)).to eq date
    end

    it 'should not accept if both are nil' do
      expect { Repository.most_recent_date(nil, nil) }.to raise_error ContractError
    end

    it 'should not accept other than Time' do
      expect { Repository.most_recent_date(nil, 2) }.to raise_error ContractError
      expect { Repository.most_recent_date([], nil) }.to raise_error ContractError
      expect { Repository.most_recent_date(nil, {}) }.to raise_error ContractError
      expect { Repository.most_recent_date(nil, true) }.to raise_error ContractError
      expect { Repository.most_recent_date(nil, 'plop') }.to raise_error ContractError
    end
  end

  describe '::from' do
    let(:octokit_repo) { Sawyer::Resource.new(Octokit.agent, name: name, updated_at: updated_at, pushed_at: pushed_at) }
    let(:most_recent_date) { Repository.most_recent_date(updated_at, pushed_at) }
    before { allow(Repository).to receive(:new).with(name: name, updated_at: most_recent_date).and_call_original }

    it 'should create a new repository with name and date' do
      allow(Repository).to receive(:most_recent_date).with(updated_at, pushed_at).and_call_original
      expect(Repository.from(octokit_repo)).to be_a Repository
      expect(Repository).to have_received(:new).with(name: name, updated_at: most_recent_date)
      expect(Repository).to have_received(:most_recent_date).with(updated_at, pushed_at)
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
