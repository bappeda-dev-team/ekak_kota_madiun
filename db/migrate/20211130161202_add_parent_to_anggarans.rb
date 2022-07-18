class AddParentToAnggarans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    # TODO - Make Self References here | warning
    # NOTE - SKIP THIS MIGRATION , you have been warned twice
    add_reference_concurrently :anggarans, :parent, class: 'Anggaran'
  end
end
