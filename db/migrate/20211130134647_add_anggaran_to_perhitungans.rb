class AddAnggaranToPerhitungans < ActiveRecord::Migration[6.1]
  def change
    add_reference :perhitungans, :anggaran, index: true, foreign: true, null: true
  end
end
