class Book < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  has_many :checkouts
  has_one :active_checkout
  after_save :add_to_index
  after_destroy :remove_from_index

  def add_to_index
    begin
      BookIndex.replace(self)
    rescue
      puts "BookIndex not available"
    end
  end

  def remove_from_index
    begin
      BookIndex.remove(id)
    rescue
      puts "BookIndex not available"
    end
  end

  def self.search keys
    ids = BookSearch.search(keys, 1000).ids
    return Book.where("id in (?)", ids)
  end
end
