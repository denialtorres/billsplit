# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :authenticate_user!

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params.require(:group).permit(:name))

    @user = current_user

    @group.users << current_user

    email_params['emails'].split(',').each do |e|
      @group.users << User.where(email: e) unless @group.users.collect { |p| (p[:email]).to_s }.include?(e)
    end

    return unless @group.save

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
end
