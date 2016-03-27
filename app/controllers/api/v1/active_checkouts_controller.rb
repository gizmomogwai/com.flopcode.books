class Api::V1::ActiveCheckoutsController < Api::ApiController
  before_filter :authenticate
  before_filter :require_admin, only: [:destroy]
  respond_to :json

  def create
    b = Book.find(params[:book])
    respond_with ActiveCheckout.for(@user, b)
  end

  def destroy
    ac = ActiveCheckout.find(params[:id])
    ac.release!(@user)
    head :ok
  end
end
