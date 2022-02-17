class AddIdOpdSkpToOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :id_opd_skp, :integer
    add_column :opds, :kode_unik_opd, :string
  end
end
