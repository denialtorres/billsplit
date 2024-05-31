# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET /index' do
    let(:user) { create(:user, :user_one) }

    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'returns a successful response' do
        get :index
        expect(response).to be_successful
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end

      it 'displays the correct user data' do
        get :index
        expect(assigns(:current_user)).to eq(user)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
