class AddJenisPeriodeToPeriodes < ActiveRecord::Migration[6.1]
  def change
    add_column :periodes, :jenis_periode, :string, default: 'RPJMD'
  end
end
