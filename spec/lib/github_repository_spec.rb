# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubRepository do
  let(:name) { Faker::App.name }
  let(:stars) { Faker::Number.between(0, 1000) }
  let(:created_at) { Faker::Time.between(3.weeks.ago, Time.zone.today) }

  describe '::new' do
    it 'should store name, stars and date' do
      repo = GithubRepository.new name: name, stars: stars, created_at: created_at
      expect(repo.name).to eq name
      expect(repo.created_at).to eq created_at
    end

    it 'should not accept other than string for name' do
      expect do
        GithubRepository.new name: 2, stars: stars, created_at: created_at
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: [], stars: stars, created_at: created_at
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: {}, stars: stars, created_at: created_at
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: nil, stars: stars, created_at: created_at
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: true, stars: stars, created_at: created_at
      end.to raise_error ContractError
    end

    it 'should not accept other than date for created_at:' do
      expect do
        GithubRepository.new name: name, stars: stars, created_at: 'plop'
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: name, stars: stars, created_at: 3
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: name, stars: stars, created_at: nil
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: name, stars: stars, created_at: []
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: name, stars: stars, created_at: {}
      end.to raise_error ContractError
      expect do
        GithubRepository.new name: name, stars: stars, created_at: true
      end.to raise_error ContractError
    end
  end

  describe '::from' do
    let(:octokit_repo) do
      Sawyer::Resource.new(Octokit.agent,
                           name: name,
                           stargazers_count: stars,
                           created_at: created_at)
    end
    before do
      allow(GithubRepository).to receive(:new).with(name: name,
                                                    stars: stars,
                                                    created_at: created_at).and_call_original
    end

    it 'should create a new repository with name and date' do
      expect(GithubRepository.from(octokit_repo)).to be_a GithubRepository
      expect(GithubRepository).to have_received(:new).with(name: name,
                                                           stars: stars,
                                                           created_at: created_at)
    end
  end

  describe '#==' do
    it 'should return true if two objects have the same values' do
      repo1 = GithubRepository.new name: name, stars: stars, created_at: created_at
      repo2 = GithubRepository.new name: name, stars: stars, created_at: created_at
      expect(repo1 == repo2).to be true
    end

    it 'should return false if two objects have different name' do
      repo1 = GithubRepository.new name: name, stars: stars, created_at: created_at
      repo2 = GithubRepository.new name: Faker::Superhero.name, stars: stars, created_at: created_at
      expect(repo1 == repo2).to be false
    end

    it 'should return false if two objects have different stars' do
      repo1 = GithubRepository.new name: name, stars: stars, created_at: created_at
      repo2 = GithubRepository.new(name: name,
                                   stars: Faker::Number.between(2000, 3000),
                                   created_at: created_at)
      expect(repo1 == repo2).to be false
    end

    it 'should return false if two objects have different date' do
      repo1 = GithubRepository.new name: name, stars: stars, created_at: created_at
      repo2 = GithubRepository.new(name: name,
                                   stars: stars,
                                   created_at: Faker::Time.between(2.days.ago, Time.zone.today))
      expect(repo1 == repo2).to be false
    end
  end
end
