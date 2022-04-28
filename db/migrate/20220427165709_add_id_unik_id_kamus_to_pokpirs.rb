class AddIdUnikIdKamusToPokpirs < ActiveRecord::Migration[6.1]
  def change
    add_column :musrenbangs, :id_unik, :bigint, unique: true
    add_column :musrenbangs, :id_kamus, :bigint
    add_column :pokpirs, :id_unik, :bigint, unique: true
    add_column :pokpirs, :id_kamus, :bigint
  end
end
