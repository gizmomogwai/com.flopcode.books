class Api::V1::BooksController < Api::ApiController
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

  private
  def set_book
    @book = Book.find(params[:id])
  end
end
