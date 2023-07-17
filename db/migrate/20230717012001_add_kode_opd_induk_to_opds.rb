class AddKodeOpdIndukToOpds < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :kode_opd_induk, :string, null: true
  end
end
