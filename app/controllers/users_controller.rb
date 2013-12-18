class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @user = User.find(params[:id])
    if @user.id == current_user.id
      @pins = @user.pins.page(params[:page]).per_page(20)
    else
      @pins = @user.pins.page(params[:page]).per_page(20).where(:publicgear => true)
    end
  end
    
end
