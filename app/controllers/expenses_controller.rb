# frozen_string_literal: true

class ExpensesController < ApplicationController
  def create
    actor = CreateExpense.call(group_id: params[:group_id],
                               payer: User.where(email: params[:email])[0],
                               total: params[:total].to_f,
                               action: params[:type],
                               members: define_members)
    return unless actor.success?

    redirect_back(fallback_location: root_path)

    # render html: ("<script>alert('"+@group.id.to_s+"')</script>").html_safe
  end

  private

  def define_members
    filtered_params = params.except(:authenticity_token, :group_id, :email, :action, :total, :commit, :controller,
                                    :type)

    return filtered_params.keys.select { |key| filtered_params[key] == '1' } if params[:type] == 'equal'

    filtered_params.to_enum
  end
end
