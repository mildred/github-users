# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubRepository do
  let(:name) { Faker::App.name }
  let(:stars) { Faker::Number.between(0, 1000) }
  let(:updated_at) { Faker::Time.between(3.weeks.ago, Time.zone.today) }
  let(:pushed_at) { Faker::Time.between(updated_at, Time.zone.today) }

  describe '::new' do
    it 'should store name, stars and date' do
      repo = GithubRepository.new name: name, stars: stars, updated_at: updated_at
      expect(repo.name).to eq name
      expect(repo.updated_at).to eq updated_at
    end

    it 'should not accept other than string for name' do
      expect do
        GithubRepository.new name: 2, stars: stars, updated_at: updated_at
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: [], stars: stars, updated_at: updated_at
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: {}, stars: stars, updated_at: updated_at
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: nil, stars: stars, updated_at: updated_at
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: true, stars: stars, updated_at: updated_at
      end.to raise_error ContractError
    end

    it 'should not accept other than date for updated_at' do
      expect do
        GithubRepository.new name: name, stars: stars, updated_at: 'plop'
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: name, stars: stars, updated_at: 3
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: name, stars: stars, updated_at: nil
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: name, stars: stars, updated_at: []
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: name, stars: stars, updated_at: {}
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: name, stars: stars, updated_at: true
      end.to raise_error ContractError
    end
  end

  describe '::most_recent_date' do
    let(:date) { Faker::Time.between(2.days.ago, Time.zone.today) }
    let(:date_before) { Faker::Time.between(3.days.ago(date), 1.day.ago(date)) }

    it 'should return the most recent date' do
      expect(GithubRepository.most_recent_date(date, date_before)).to eq date
      expect(GithubRepository.most_recent_date(date_before, date)).to eq date
    end

    it 'should return the non nil date if one is nil' do
      expect(GithubRepository.most_recent_date(date, nil)).to eq date
      expect(GithubRepository.most_recent_date(nil, date)).to eq date
    end

    it 'should not accept if both are nil' do
      expect { GithubRepository.most_recent_date(nil, nil) }.to raise_error ContractError
    end

    it 'should not accept other than Time' do
      expect { GithubRepository.most_recent_date(nil, 2) }.to raise_error ContractError
      expect { GithubRepository.most_recent_date([], nil) }.to raise_error ContractError
      expect { GithubRepository.most_recent_date(nil, {}) }.to raise_error ContractError
      expect { GithubRepository.most_recent_date(nil, true) }.to raise_error ContractError
      expect { GithubRepository.most_recent_date(nil, 'plop') }.to raise_error ContractError
    end
  end

  describe '::from' do
    let(:octokit_repo) do
      Sawyer::Resource.new(Octokit.agent,
                           name: name,
                           stargazers_count: stars,
                           updated_at: updated_at,
                           pushed_at: pushed_at)
    end
    let(:most_recent_date) { GithubRepository.most_recent_date(updated_at, pushed_at) }
    before do
      allow(GithubRepository).to receive(:new).with(name: name,
                                                    stars: stars,
                                                    updated_at: most_recent_date).and_call_original
    end

    it 'should create a new repository with name and date' do
      allow(GithubRepository).to receive(:most_recent_date).with(updated_at, pushed_at).and_call_original
      expect(GithubRepository.from(octokit_repo)).to be_a GithubRepository
      expect(GithubRepository).to have_received(:new).with(name: name,
                                                           stars: stars,
                                                           updated_at: most_recent_date)
      expect(GithubRepository).to have_received(:most_recent_date).with(updated_at, pushed_at)
    end
  end

  describe '#==' do
    it 'should return true if two objects have the same values' do
      repo1 = GithubRepository.new name: name, stars: stars, updated_at: updated_at
      repo2 = GithubRepository.new name: name, stars: stars, updated_at: updated_at
      expect(repo1 == repo2).to be true
    end

    it 'should return false if two objects have different name' do
      repo1 = GithubRepository.new name: name, stars: stars, updated_at: updated_at
      repo2 = GithubRepository.new name: Faker::Superhero.name, stars: stars, updated_at: updated_at
      expect(repo1 == repo2).to be false
    end

    it 'should return false if two objects have different stars' do
      repo1 = GithubRepository.new name: name, stars: stars, updated_at: updated_at
      repo2 = GithubRepository.new(name: name,
                                   stars: Faker::Number.between(2000, 3000),
                                   updated_at: updated_at)
      expect(repo1 == repo2).to be false
    end

    it 'should return false if two objects have different date' do
      repo1 = GithubRepository.new name: name, stars: stars, updated_at: updated_at
      repo2 = GithubRepository.new(name: name,
                                   stars: stars,
                                   updated_at: Faker::Time.between(2.days.ago, Time.zone.today))
      expect(repo1 == repo2).to be false
    end
  end
end
