class AddJenisOutputToManualIks < ActiveRecord::Migration[6.1]
  def change
    add_column :manual_iks, :jenis_output, :string
  end
end
