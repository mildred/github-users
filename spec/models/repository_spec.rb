# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository do
  it { should belong_to(:user) }
  it { expect(ActiveRecord::Base.connection.column_exists?(User.table_name, :last_activity_at)) }
  it { expect(ActiveRecord::Base.connection.column_exists?(User.table_name, :name)) }

  describe '::create_or_update' do
    let(:name) { Faker::Superhero.name }
    let(:updated_at) { Faker::Time.between(10.days.ago, Time.zone.today) }
    let(:github_repository) { GithubRepository.new(name: name, updated_at: updated_at) }

    context 'repository does not exists' do
      it 'should create the repository' do
        Repository.create_or_update github_repository
        expect(Repository.find_by(name: name)).not_to be_nil
        expect(Repository.find_by(name: name).name).to eq name
        expect(Repository.find_by(name: name).last_activity_at.utc).to eq updated_at.utc
      end
    end

    context 'repository exists' do
      let(:old_updated_at) { Faker::Time.between(10.days.ago, Time.zone.today) }
      before do
        Repository.create_or_update GithubRepository.new(name: name, updated_at: old_updated_at)
      end

      it 'should update the repository' do
        expect do
          Repository.create_or_update github_repository
        end.to change {
          Repository.find_by(name: name).last_activity_at
        }.from(old_updated_at.utc).to(updated_at.utc)
      end
    end
  end
end
