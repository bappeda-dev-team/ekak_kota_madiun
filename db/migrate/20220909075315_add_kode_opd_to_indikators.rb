class AddKodeOpdToIndikators < ActiveRecord::Migration[6.1]
  def change
    add_column :indikators, :kode_opd, :string, null: true
  end
end
