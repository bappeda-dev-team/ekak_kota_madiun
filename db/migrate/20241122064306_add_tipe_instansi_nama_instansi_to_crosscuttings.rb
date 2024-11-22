class AddTipeInstansiNamaInstansiToCrosscuttings < ActiveRecord::Migration[6.1]
  def change
    add_column :crosscuttings, :tipe_instansi, :string
    add_column :crosscuttings, :nama_instansi, :string
  end
end
