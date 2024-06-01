# frozen_string_literal: true

# this is the controller for groups
class GroupsController < ApplicationController
  before_action :authenticate_user!

  def new
    @group = Group.new
  end

  def create
    actor = CreateGroup.call(main_user: current_user,
                             group_params: group_params,
                             team_emails: email_params['emails'])

    return unless actor.success?

    redirect_to root_path
  end

  def show
    @group = Group.find_by(id: params[:id])
    if @group.nil?
      redirect_to root_path
    else
      @expenses = Expense.where(group_id: @group.id)
    end
  end

  private

  def email_params
    params.require(:group).permit(:emails)
  end

  def group_params
    params.require(:group)
  end
end
