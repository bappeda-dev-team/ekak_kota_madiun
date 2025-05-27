class AddDataDanInformasiToManualIks < ActiveRecord::Migration[6.1]
  def change
    add_column :manual_iks, :data_dan_informasi, :string, array: true, default: [""]
  end
end
