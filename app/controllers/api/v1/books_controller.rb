class Api::V1::BooksController < Api::ApiController
  include BooksHelper
  respond_to :json
  before_filter :authenticate
  before_filter :set_book, only: [:show]
  before_filter :require_admin, only: [:create]

  def index
    respond_with Book.all.map { |book|
      {
        id: book.id,
        isbn: book.isbn,
        title: book.title,
        authors: book.authors,
        user_id: book.user&.id,
        location_id: book.location&.id,
        active_checkout_id: book.active_checkout&.checkout&.user&.id
      }
    }
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
