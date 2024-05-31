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
end
