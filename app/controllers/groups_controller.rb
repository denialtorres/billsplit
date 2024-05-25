class GroupsController < ApplicationController
  before_action :authenticate_user!

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params.require(:group).permit(:name))

    @user = current_user

    @group.users << current_user

    email_params["emails"].split(",").each do |e|
      if !@group.users.collect {|p| "#{p[:email]}"}.include?(e)
        @group.users << User.where(email: e)
      end
    end

    if @group.save
      redirect_to root_path
    end
  end

  def show
    @group = Group.find_by_id(params[:id])
    @expenses = Expense.where(group_id: @group.id)
  end

  private

  def email_params
    params.require(:group).permit(:emails)
  end
end
