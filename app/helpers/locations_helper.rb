module LocationsHelper
  def location_params
    params.require(:location).permit(:name, :description)
  end

  def set_location_from_parameters
    @location = Location.find(params[:id])
  end
end
