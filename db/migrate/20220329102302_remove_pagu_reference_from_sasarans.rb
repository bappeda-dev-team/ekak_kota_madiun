class RemovePaguReferenceFromSasarans < ActiveRecord::Migration[6.1]
  def change
    remove_reference :pagus, :sasaran, null: false, foreign_key: true
  end
end
