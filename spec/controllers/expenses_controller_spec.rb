# frozen_string_literal: true

# The create action in the /app/controllers/expenses_controller.rb file does the following to split the expenses equally:
# Subtract the expense per person from every person’s arrears and update the row in the expenses table.
# For the person who paid the expense, add the total amount paid to their arrears and subtract the expense per person if they checked their name.
# If their name is unchecked, add the total amount and update the record.
require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  describe 'POST #create' do
    let(:group) { create(:group, :with_users) }
    let(:user_one) { group.users.first }
    let(:user_two) { group.users.second }
    let(:user_three) { group.users.third }

    context 'for dividing 100 equally between two people' do
      let(:equal_params) do
        {
          group_id: group.id,
          email: user_one.email,
          total: 100,
          user_one.id => '1',
          user_two.id => '1',
          type: 'equal'
        }
      end

      it 'assigns the requested expenses' do
        expenses = Expense.where(group_id: group.id)

        post :create, params: equal_params

        expect(expenses.pluck(:amount)).to contain_exactly(nil, -50.0, 50.0)
      end

      it "redirects to the created group's page" do
        post :create, params: equal_params

        expect(response).to redirect_to(root_path)
      end
    end

    context 'for dividing 1 equally between three people' do
      let(:equal_params) do
        {
          group_id: group.id,
          email: user_one.email,
          total: 1,
          user_one.id => '1',
          user_two.id => '1',
          user_three.id => '1',
          type: 'equal'
        }
      end

      it 'assigns the requested expenses' do
        expenses = Expense.where(group_id: group.id)

        post :create, params: equal_params

        expect(expenses.pluck(:amount)).to contain_exactly(0.67, -0.33, -0.33)
      end

      it "redirects to the created group's page" do
        post :create, params: equal_params

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
