# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe 'GET /new' do
    let(:user) { create(:user, :user_one) }

    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'assigns a new group instance' do
        get :new
        expect(assigns(:group)).to be_a_new(Group)
      end

      it 'renders the new template' do
        get :new
        expect(response).to render_template(:new)
      end

      it 'initializes the group with nil values' do
        get :new
        expect(assigns(:group).name).to eq(nil)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    let(:user_one) { create(:user, :user_one) }
    let(:user_two) { create(:user, :user_two) }
    let(:user_three) { create(:user, :user_three) }

    let(:valid_params) do
      {
        group: {
          name: 'Test Group',
          emails: 'jane@educative.io,mike@educative.io'
        }
      }
    end

    let(:invalid_params) do
      {
        group: {
          name: 'Test Group',
          emails: 'jake@educative.io,anna@educative.io,xyz'
        }
      }
    end

    context 'when the user is authenticated' do
      before do
        user_two
        user_three
        sign_in user_one
      end

      it 'creates a new group with users' do
        expect do
          post :create, params: valid_params
        end.to change(Group, :count).by(1)
      end

      it 'matches the name of the group' do
        post :create, params: valid_params
        group = Group.last
        expect(group.name).to eq('Test Group')
      end

      it 'matches group members' do
        post :create, params: valid_params
        group = Group.last
        expect(group.users.count).to eq(3)
        expect(group.users.pluck(:email)).to contain_exactly('john@educative.io', 'jane@educative.io',
                                                             'mike@educative.io')
      end

      it "redirects to the created group's page" do
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it 'invalid emails' do
        post :create, params: invalid_params
        group = Group.last
        expect(group.name).to eq('Test Group')
        expect(group.users.count).to eq(1)
        expect(group.users.pluck(:email)).to contain_exactly('john@educative.io')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    let(:group) { create(:group, :with_users) }
    let(:user_one) { group.users.first }
    let(:user_two) { group.users.second }
    let(:user_three) { group.users.third }

    let(:valid_params) do
      {
        id: group.id
      }
    end

    context 'when user is authenticated' do
      before do
        sign_in user_one
      end

      it 'verifies the group details' do
        get :show, params: valid_params

        expect(assigns(:group)).to eq(group)
      end

      it 'matches expenses array' do
        expenses = Expense.where(group_id: group.id)

        get :show, params: valid_params

        expect(assigns(:expenses)).to match_array(expenses)
      end

      it 'matches expenses array with correct attributes' do
        expenses = Expense.where(group_id: group.id)

        get :show, params: valid_params

        expect(assigns(:expenses).pluck(:amount)).to match_array(expenses.pluck(:amount))
      end

      it 'renders the show template' do
        get :show, params: valid_params
        expect(response).to render_template(:show)
      end

      it 'handles wrong group id gracefully' do
        get :show, params: { id: -1 }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
