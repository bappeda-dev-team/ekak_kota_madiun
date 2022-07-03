class RemoveKakAddSasaranToPagus < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    remove_index :pagus, :index_pagus_on_kak_id, algorithm: :concurrently
    add_reference_concurrently :pagus, :sasaran, null: false, foreign_key: true
  end
end
