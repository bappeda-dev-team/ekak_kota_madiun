class AddIndexToStatusUsulan < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  def change
    add_index :musrenbangs, :status, algorithm: :concurrently
    add_index :pokpirs, :status, algorithm: :concurrently
    add_index :mandatoris, :status, algorithm: :concurrently
    add_index :inovasis, :status, algorithm: :concurrently
  end
end
