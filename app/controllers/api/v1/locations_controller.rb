class Api::V1::LocationsController < Api::ApiController
  respond_to :json
  before_filter :authenticate

  def index
    @locations = Location.all
    respond_with @locations
  end

end
