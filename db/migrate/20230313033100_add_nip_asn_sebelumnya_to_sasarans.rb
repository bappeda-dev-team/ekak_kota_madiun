class AddNipAsnSebelumnyaToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :nip_asn_sebelumnya, :string, null: true
  end
end
