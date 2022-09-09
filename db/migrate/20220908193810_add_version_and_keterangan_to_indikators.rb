class AddVersionAndKeteranganToIndikators < ActiveRecord::Migration[6.1]
  def change
    add_column :indikators, :version, :integer, null: false, default: 0
    add_column :indikators, :keterangan, :string, null: true
  end
end
