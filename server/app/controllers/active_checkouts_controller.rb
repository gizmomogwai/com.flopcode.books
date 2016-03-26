class ActiveCheckoutsController < ApplicationController
  before_filter :authenticate_user
  rescue_from ActiveCheckout::WrongUser, with: -> () {
    head :forbidden
  }

  rescue_from ActiveCheckout::BookTaken, with: -> () {
    head :locked
  }

  def create
    p = active_checkout_params
    @active_checkout = ActiveCheckout.for(@logged_in_user, Book.find(p[:book]))
    redirect_to root_path
  end

  def destroy
    ac = ActiveCheckout.find(params[:id])
    ac.release(@logged_in_user)
    redirect_to root_path
  end

  private
  def active_checkout_params
    params.require(:active_checkout).permit([:book])
  end
end
