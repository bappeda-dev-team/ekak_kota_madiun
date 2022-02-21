class AddOpdAndNipToMusrenbangs < ActiveRecord::Migration[6.1]
  def change
    add_column :musrenbangs, :opd, :string, null: true
    add_column :musrenbangs, :nip_asn, :string, null: true
  end
end
