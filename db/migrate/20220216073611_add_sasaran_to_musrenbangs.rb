class AddSasaranToMusrenbangs < ActiveRecord::Migration[6.1]
   disable_ddl_transaction!
   
   def change
    add_reference_concurrently :musrenbangs, :sasaran, null: true, index: true
  end
end
