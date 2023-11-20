class AddFaktorPenghambatSkpToPermasalahanOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :permasalahan_opds, :faktor_penghambat_skp, :string, null: true
  end
end
