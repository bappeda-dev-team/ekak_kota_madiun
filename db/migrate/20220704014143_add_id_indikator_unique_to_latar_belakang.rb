class AddIdIndikatorUniqueToLatarBelakang < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  
  def change
    add_column :latar_belakangs, :id_indikator_sasaran, :string, unique: true
    add_index :latar_belakangs, :id_indikator_sasaran, unique: true, algorithm: :concurrently
  end
end
