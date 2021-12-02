class AddPerhitunganToKoefisiens < ActiveRecord::Migration[6.1]
  def change
    add_reference :koefisiens, :perhitungan, index: true, null: true
  end
end
