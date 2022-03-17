class AddSasaranToUsulans < ActiveRecord::Migration[6.1]
  def change
    add_reference :usulans, :sasaran, null: true, index: true
  end
end
