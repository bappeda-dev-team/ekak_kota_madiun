class AddKakToSasaran < ActiveRecord::Migration[6.1]
  def up
    add_reference :sasarans, :kak, null: true, index: true
  end
  
  def down 
    remove_reference :sasarans, :kak, null: true, index: true
  end
end
