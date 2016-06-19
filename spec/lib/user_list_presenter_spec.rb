# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserListPresenter do
  describe '::new' do
    it 'should accept User relation' do
      expect { UserListPresenter.new(User.all) }.not_to raise_error
    end

    it 'should not accept other than User relation' do
      expect { UserListPresenter.new(User.new(login: Faker::Superhero.name)) }.to raise_error ContractError
      expect { UserListPresenter.new([User.new(login: Faker::Superhero.name)]) }.to raise_error ContractError
      expect { UserListPresenter.new([]) }.to raise_error ContractError
      expect { UserListPresenter.new(2) }.to raise_error ContractError
      expect { UserListPresenter.new(true) }.to raise_error ContractError
      expect { UserListPresenter.new({}) }.to raise_error ContractError
    end

    before do
      FactoryGirl.create_list(:user_with_repositories, Faker::Number.between(10, 30))
    end
    let(:users) { User.all }
    it 'should order users by name' do
      allow(users).to receive(:order).with(:name)
      UserListPresenter.new users
      expect(users).to have_received(:order).with(:name)
    end
  end
end
