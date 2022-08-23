class AddRincianReferencesToSkalasTable < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  def change
    add_reference_concurrently :skalas, :rincian, null: true
  end
end
