# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPresenter do
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
  let(:name) { Faker::Superhero.name }
  let(:user_name) { Faker::Superhero.name }
  let(:user) do
    GithubUser.new(login: user_name,
                   name: name,
                   repositories: repositories)
  end

  describe '::new' do
    it 'should accept User' do
      expect { UserPresenter.new(user) }.not_to raise_error
    end

    it 'should not accept other than User' do
      expect { UserPresenter.new(2) }.to raise_error ContractError
      expect { UserPresenter.new(nil) }.to raise_error ContractError
      expect { UserPresenter.new([]) }.to raise_error ContractError
      expect { UserPresenter.new([GithubUser]) }.to raise_error ContractError
      expect { UserPresenter.new({}) }.to raise_error ContractError
      expect { UserPresenter.new(true) }.to raise_error ContractError
      expect { UserPresenter.new(repositories.first) }.to raise_error ContractError
    end
  end

  subject { UserPresenter.new(user) }

  it { expect(subject.user).to eq(user) }
  it { expect(subject.name).to eq(user.name) }
  it { expect(subject.repositories).to eq(repositories.sort_by(&:updated_at).reverse) }
end
