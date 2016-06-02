def startIndex
  BookIndex.index
end

def restartIndex
  begin
    BookIndex.load
  rescue
    startIndex
  end
  at_exit { BookIndex.dump }
end

puts "BookTable #{Book.table_exists?}"
if Book.table_exists?
  BookIndex = Picky::Index.new :books do
    source Book.all
    category :title, similarity: Picky::Similarity::Soundex.new
    category :authors, similarity: Picky::Similarity::Soundex.new
  end

  BookSearch = Picky::Search.new(BookIndex)

  startIndex # or restartIndex
end
