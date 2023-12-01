class AddJenisOutputToManualIks < ActiveRecord::Migration[6.1]
  def change
    add_column :manual_iks, :output_data, :string, array: true, default: ['kinerja']
  end
end
