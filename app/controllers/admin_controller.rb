class AdminController < ApplicationController
  #before_action :check_admin


  private

  def check_admin
    return if current_user && @current_user.permission >= 100
    redirect_to "/"
  end

end