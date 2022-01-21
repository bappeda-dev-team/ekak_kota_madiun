class RemoveKakFromSasarans < ActiveRecord::Migration[6.1]
  def change
    remove_reference :sasarans, :kak, null: true, index: true
  end
end
