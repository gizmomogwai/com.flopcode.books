module BooksHelper
  def book_params
    params.require(:book).permit(:isbn, :title, :authors, :owner_id, :location_id, :user_id)
  end

  def set_book_from_parameters
    @book = Book.find(params[:id])
  end
end
