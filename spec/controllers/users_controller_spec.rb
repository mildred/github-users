# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET index' do
    context 'without users' do
      it 'should render index' do
        get :index
        expect(response).to render_template(:index)
      end

      it 'should display an alert' do
        get :index
        expect(flash[:alert]).to eq EmptyUserList.instance.message
      end
    end

    context 'with users' do
      before do
        FactoryGirl.create_list(:user_with_repositories, Faker::Number.between(10, 30))
      end

      it 'should render index' do
        get :index
        expect(response).to render_template(:index)
      end

      it 'should not display an error message' do
        get :index
        expect(flash[:alert]).to be_nil
      end

      it 'should assign UserListPresenter' do
        get :index
        expect(assigns(:users)).to be_a UserListPresenter
      end

      it 'should call presenter with all users' do
        allow(UserListPresenter).to receive(:new).with(User.all)
        get :index
        expect(UserListPresenter).to have_received(:new).with(User.all)
      end
    end
  end
end
