class AddIdAnggaranToPaguAnggaran < ActiveRecord::Migration[6.1]
  def change
    add_column :pagu_anggarans, :id_anggaran, :integer, null: true
  end
end
