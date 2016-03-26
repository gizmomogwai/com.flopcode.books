class LocationsController < ApplicationController
  include LocationsHelper
  before_action :set_location_from_parameters, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user
  before_filter :admin_user, only: [:edit, :update, :destroy]
  respond_to :html

  def index
    @locations = Location.all
    respond_with @locations
  end

  def show
  end
  #
  #  # GET /books/new
  #  def new
  #    @book = Book.new
  #  end
  #
  #  # GET /books/1/edit
  #  def edit
  #  end
  #
  #  # POST /books
  #  def create
  #    @book = Book.new(book_params)
  #    @book.save!
  #    redirect_to @book, notice: 'Book was successfully created.'
  #  end
  #
  #  # PATCH/PUT /books/1
  #  def update
  #    @book.update!(book_params)
  #    redirect_to @book, notice: 'Book was successfully updated.'
  #  end
  #
  #  # DELETE /books/1
  #  def destroy
  #    @book.destroy
  #    redirect_to books_url, notice: 'Book was successfully destroyed.'
  #  end

end
