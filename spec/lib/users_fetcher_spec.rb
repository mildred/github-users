# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersFetcher do
  describe '::new' do
    it 'should accept a listener with users_found and users_not_found methods' do
      Listener = Class.new do
        def users_found; end

        def users_not_found; end
      end

      expect { UsersFetcher.new(Listener.new) }.not_to raise_error
    end

    it 'should not accept a listener without users_found' do
      ListenerNoUsersFound = Class.new do
        def users_found_; end

        def users_not_found; end
      end

      expect { UsersFetcher.new(ListenerNoUsersFound.new) }.to raise_error ContractError
    end

    it 'should not accept a listener without users_not_found' do
      ListenerNoUsersNotFound = Class.new do
        def users_found; end

        def users_not_found_; end
      end

      expect { UsersFetcher.new(ListenerNoUsersNotFound.new) }.to raise_error ContractError
    end
  end

  describe '#fetch_users' do
    let(:listener) do
      Class.new do
        def users_found(user); end

        def users_not_found(name); end
      end.new
    end

    subject { UsersFetcher.new(listener) }

    context 'without users' do
      it 'should call the users_not_found' do
        allow(listener).to receive(:users_not_found).with(EmptyUserList.instance)
        subject.fetch_users
        expect(listener).to have_received(:users_not_found).with(EmptyUserList.instance)
      end
    end

    context 'with users' do
      before do
        FactoryGirl.create_list(:user_with_repositories, Faker::Number.between(10, 30))
      end

      it 'should call the users_found' do
        allow(listener).to receive(:users_found).with(User.all)
        subject.fetch_users
        expect(listener).to have_received(:users_found).with(User.all)
      end
    end
  end
end
