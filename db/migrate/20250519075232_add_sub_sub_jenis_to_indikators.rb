class AddSubSubJenisToIndikators < ActiveRecord::Migration[6.1]
  def change
    add_column :indikators, :sub_sub_jenis, :string, null: true
  end
end
