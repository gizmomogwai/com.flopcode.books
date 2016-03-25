class ActiveCheckoutsController < ApplicationController
  before_filter :authenticate_user
  rescue_from ActiveCheckout::WrongUser, with: -> () {
    puts 5
    head :forbidden
  }

  def create
    p = active_checkout_params
    @active_checkout = ActiveCheckout.for(@logged_in_user, Book.find(p[:book]))
    redirect_to root_path
  end

  def destroy
    puts 1
    ac = ActiveCheckout.find(params[:id])
    puts 2
    ac.release(@logged_in_user)
    puts 3
    redirect_to root_path
    puts 4
  end

  private
  def active_checkout_params
    params.require(:active_checkout).permit([:book])
  end
end
