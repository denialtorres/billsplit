class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @group = current_user.groups
  end
end
