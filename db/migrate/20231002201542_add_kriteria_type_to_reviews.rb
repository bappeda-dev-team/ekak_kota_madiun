class AddKriteriaTypeToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :kriteria_type, :string
  end
end
