class AddReformulasiTujuanDataTerpilahIndikatorTargetSatuanToGenders < ActiveRecord::Migration[6.1]
  def change
    add_column :genders, :reformulasi_tujuan, :string
    add_column :genders, :data_terpilah, :string
    add_column :genders, :indikator, :string
    add_column :genders, :target, :string
    add_column :genders, :satuan, :string
    add_column :genders, :penyebab_internal, :string
    add_column :genders, :penyebab_external, :string
  end
end
