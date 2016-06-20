# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository do
  it { should belong_to(:user) }
  it { expect(ActiveRecord::Base.connection.column_exists?(User.table_name, :repo_created_at)) }
  it { expect(ActiveRecord::Base.connection.column_exists?(User.table_name, :name)) }

  describe '::create_or_update' do
    let(:name) { Faker::Superhero.name }
    let(:created_at) { Faker::Time.between(10.days.ago, Time.zone.today) }
    let(:stars) { Faker::Number.between(0, 100) }
    let(:github_repository) { GithubRepository.new(name: name, stars: stars, created_at: created_at) }

    context 'repository does not exists' do
      it 'should create the repository' do
        Repository.create_or_update github_repository
        expect(Repository.find_by(name: name)).not_to be_nil
        expect(Repository.find_by(name: name).name).to eq name
        expect(Repository.find_by(name: name).repo_created_at.utc).to eq created_at.utc
      end
    end

    context 'repository exists' do
      let(:old_created_at) { Faker::Time.between(10.days.ago, Time.zone.today) }
      before do
        Repository.create_or_update GithubRepository.new(name: name, stars: stars, created_at: old_created_at)
      end

      it 'should update the repository' do
        expect do
          Repository.create_or_update github_repository
        end.to change {
          Repository.find_by(name: name).repo_created_at
        }.from(old_created_at.utc).to(created_at.utc)
      end
    end
  end
end
