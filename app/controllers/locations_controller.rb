class LocationsController < ApplicationController
  include LocationsHelper
  before_action :set_location_from_parameters, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user
  before_filter :admin_user, only: [:new, :create, :edit, :update, :destroy]
  respond_to :html

  def index
    @locations = Location.all
    respond_with @locations
  end

  def show
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    @location.save!
    redirect_to @location, notice: 'Location was successfully created.'
  end

  def destroy
    @location.destroy
    redirect_to locations_url, notice: 'Location was successfully destroyed.'
  end
  #
  #  # GET /books/1/edit
  #  def edit
  #  end
  #
  #
  #  # PATCH/PUT /books/1
  #  def update
  #    @book.update!(book_params)
  #    redirect_to @book, notice: 'Book was successfully updated.'
  #  end
  #

end
