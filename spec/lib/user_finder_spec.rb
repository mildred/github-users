# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserFinder do
  describe '::new' do
    it 'should accept a listener with user_found and user_not_found methods' do
      Listener = Class.new do
        def user_found; end

        def user_not_found; end
      end

      expect { UserFinder.new(Listener.new) }.not_to raise_error
    end

    it 'should not accept a listener without user_found' do
      ListenerNoUserFound = Class.new do
        def user_found_; end

        def user_not_found; end
      end

      expect { UserFinder.new(ListenerNoUserFound.new) }.to raise_error ContractError
    end

    it 'should not accept a listener without user_not_found' do
      ListenerNoUserNotFound = Class.new do
        def user_found; end

        def user_not_found_; end
      end

      expect { UserFinder.new(ListenerNoUserNotFound.new) }.to raise_error ContractError
    end
  end

  describe '#find_by_name' do
    let(:listener) do
      Class.new do
        def user_found(user); end

        def user_not_found(name); end
      end.new
    end

    before { class_double('Octokit').as_null_object }
    let(:name) { Faker::Superhero.name }
    subject { UserFinder.new(listener) }

    context 'parameter validation' do
      it 'should accept a string' do
        expect { subject.find_by_name(name) }.not_to raise_error
      end

      it 'should not accept other than string' do
        expect { subject.find_by_name(2) }.to raise_error ContractError
        expect { subject.find_by_name([]) }.to raise_error ContractError
        expect { subject.find_by_name(true) }.to raise_error ContractError
        expect { subject.find_by_name(nil) }.to raise_error ContractError
        expect { subject.find_by_name({}) }.to raise_error ContractError
      end
    end

    context 'with invalid github user' do
      before { allow(Octokit).to receive(:user).with(name).and_raise Octokit::NotFound }
      before { allow(listener).to receive(:user_not_found) }

      it 'should call the user_not_found method with an invalid github user object' do
        subject.find_by_name name
        expect(listener).to have_received(:user_not_found).with(instance_of(InvalidGithubUser))
      end
    end

    context 'with a valid github user' do
      let(:user_name) { Faker::Superhero.name }
      let(:user) { User.new(login: user_name, name: name) }
      let(:octokit_user) { Sawyer::Resource.new(Octokit.agent, login: user_name, name: name) }
      before { allow(Octokit).to receive(:user).with(name).and_return(octokit_user) }
      before { allow(listener).to receive(:user_found) }

      it 'should call the user_found method with the user' do
        subject.find_by_name name
        expect(listener).to have_received(:user_found).with(user)
      end
    end
  end
end
