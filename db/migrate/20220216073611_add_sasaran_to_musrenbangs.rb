class AddSasaranToMusrenbangs < ActiveRecord::Migration[6.1]
  def change
    add_reference :musrenbangs, :sasaran, null: true, index: true
  end
end
