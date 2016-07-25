class RemoveTitleFromChirps < ActiveRecord::Migration[5.0]
  def change
    remove_column :chirps, :title, :string
  end
end
