class AddIsuStrategisToProgramKegiatans < ActiveRecord::Migration[6.1]
  def change
    add_column :program_kegiatans, :isu_strategis, :string, null: true
  end
end
