class AddKelompokToProgramUnggulans < ActiveRecord::Migration[6.1]
  def change
    add_column :program_unggulans, :kelompok, :string
  end
end
