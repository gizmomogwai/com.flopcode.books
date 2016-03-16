class Api::V1::ActiveCheckoutsController < Api::ApiController
  before_filter :authenticate
  respond_to :json

  def create
    b = Book.find(params[:book])
    respond_with ActiveCheckout.for(@user, b)
  end

  def destroy
    ac = ActiveCheckout.find(params[:id])
    head ac.release(@user)
  end
end
end
