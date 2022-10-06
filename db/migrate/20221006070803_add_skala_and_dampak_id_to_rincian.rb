class AddSkalaAndDampakIdToRincian < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  def change
    remove_index :skalas, name: :index_skalas_on_rincian_id, algorithm: :concurrently
    add_reference_concurrently :rincians, :skala, index: true
  end
end
