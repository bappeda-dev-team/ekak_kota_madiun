class AddPenilaianToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :penilaian, :string, null: true
  end
end
