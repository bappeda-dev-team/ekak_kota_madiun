class AddNipAsnSebelumnyaToStrategis < ActiveRecord::Migration[6.1]
  def change
    add_column :strategis, :nip_asn_sebelumnya, :string, null: true
  end
end
