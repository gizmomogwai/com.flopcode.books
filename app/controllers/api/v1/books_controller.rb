class Api::V1::BooksController < Api::ApiController
  include BooksHelper
  respond_to :json
  before_filter :authenticate
  before_filter :set_book, only: [:show]

  def index
    @books = Book.all
    respond_with @books
  end

  def show
    respond_with @book
  end

  def create
    respond_with Book.create(book_params)
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end
end
