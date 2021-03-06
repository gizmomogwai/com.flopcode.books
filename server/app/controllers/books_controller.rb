class BooksController < ApplicationController
  include BooksHelper

  # protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
  before_action :set_book_from_parameters, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user
  before_filter :admin_user, only: [:edit, :destroy, :update, :new, :create]
  respond_to :html

  # GET /books
  def index
    if params[:query]
      @books = Book.search(params[:query])
    else
      @books = Book.all
    end
    respond_with @books
  end

  # GET /books/1
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  def create
    @book = Book.new(book_params)
    @book.save!
    redirect_to @book, notice: 'Book was successfully created.'
  end

  # PATCH/PUT /books/1
  def update
    @book.update!(book_params)
    redirect_to @book, notice: 'Book was successfully updated.'
  end

  # DELETE /books/1
  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Book was successfully destroyed.'
  end
end
