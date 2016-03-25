class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:show]
  before_action :authenticate_user
  respond_to :html

  def index
    @checkouts = Checkout.all
    respond_with @checkouts
  end

  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_checkout
    @checkout = Checkout.find(params[:id])
  end
end
