class AddKodeUnikOpdToAset < ActiveRecord::Migration[6.1]
  def change
    add_column :asets, :kode_unik_opd, :string, null: true
  end
end
