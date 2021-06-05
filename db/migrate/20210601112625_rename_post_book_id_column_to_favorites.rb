class RenamePostBookIdColumnToFavorites < ActiveRecord::Migration[5.2]
  def change
    rename_column :favorites, :post_book_id, :book_id
  end
end
