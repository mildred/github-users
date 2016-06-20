# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it { should have_many(:repositories) }
  it { expect(ActiveRecord::Base.connection.column_exists?(User.table_name, :login)) }
  it { expect(ActiveRecord::Base.connection.column_exists?(User.table_name, :name)) }
  it { expect(ActiveRecord::Base.connection.column_exists?(User.table_name, :followers)) }

  describe '::create_or_update' do
    let(:repositories) do
      [
        GithubRepository.new(name: Faker::Superhero.name,
                             stars: Faker::Number.between(0, 100),
                             created_at: Faker::Time.between(10.days.ago, Time.zone.today)),
        GithubRepository.new(name: Faker::Superhero.name,
                             stars: Faker::Number.between(0, 100),
                             created_at: Faker::Time.between(10.days.ago, Time.zone.today))
      ]
    end
    let(:user_name) { Faker::Superhero.name }
    let(:name) { Faker::Superhero.name }
    let(:stars) { repositories.map(&:stars).inject(0, &:+) }
    let(:github_user) do
      GithubUser.new(login: user_name,
                     name: name,
                     repositories: repositories)
    end

    context 'user does not exists' do
      it 'should create the user' do
        User.create_or_update github_user
        expect(User.find_by(login: user_name)).not_to be_nil
        expect(User.find_by(login: user_name).name).to eq name
        expect(User.find_by(login: user_name).stars).to eq stars
        expect(User.find_by(login: user_name).repositories).not_to be_empty
      end
    end

    context 'user exists' do
      let(:old_name) { Faker::Superhero.name }
      let(:old_stars) { 0 }
      before do
        User.create_or_update GithubUser.new(login: user_name,
                                             name: old_name,
                                             repositories: [])
      end

      it 'should update the user' do
        expect do
          User.create_or_update github_user
        end.to change { User.find_by(login: user_name).name }.from(old_name).to(name)
      end

      it 'should update the stars' do
        expect do
          User.create_or_update github_user
        end.to change { User.find_by(login: user_name).stars }.from(old_stars).to(stars)
      end
    end
  end
end
