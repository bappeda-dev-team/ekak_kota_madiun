class AddKakToSasaran < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    add_reference_concurrently :sasarans, :kak, null: true, index: true
  end
  
  def down 
    remove_reference :sasarans, :kak, null: true, index: true
  end
end
