# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvalidGithubUser do
  describe '::new' do
    it 'should accept a string' do
      expect { InvalidGithubUser.new('a user') }.not_to raise_error
    end

    it 'should not accept other than string' do
      expect { InvalidGithubUser.new(2) }.to raise_error ContractError
      expect { InvalidGithubUser.new([]) }.to raise_error ContractError
      expect { InvalidGithubUser.new(true) }.to raise_error ContractError
      expect { InvalidGithubUser.new(nil) }.to raise_error ContractError
      expect { InvalidGithubUser.new({}) }.to raise_error ContractError
    end
  end

  describe '#message' do
    let(:name) { Faker::Superhero.name }
    let(:message) { "'#{name}' is not a valid github username." }
    subject { InvalidGithubUser.new(name) }

    it 'should format an error message' do
      expect(subject.message).to eq message
    end
  end
end
