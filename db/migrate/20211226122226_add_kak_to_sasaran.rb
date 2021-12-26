class AddKakToSasaran < ActiveRecord::Migration[6.1]
  def change
    add_reference :sasarans, :kak, null: true, index: true
  end
end
