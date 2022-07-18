class RemovePaguReferenceFromSasarans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    remove_index :pagus, name: :index_pagus_on_sasaran_id, algorithm: :concurrently
  end
end
