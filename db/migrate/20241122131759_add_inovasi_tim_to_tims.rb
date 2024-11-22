class AddInovasiTimToTims < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :tims, :inovasi_tim, null: false, foreign_key: true
  end
end
