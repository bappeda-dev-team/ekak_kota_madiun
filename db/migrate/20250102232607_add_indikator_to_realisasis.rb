class AddIndikatorToRealisasis < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  def change
    add_reference_concurrently :realisasis, :indikator, null: false, foreign_key: true
  end
end
