class ValidateAddSasaranIdToPermasalahans < ActiveRecord::Migration[6.1]
  def change
    validate_foreign_key :permasalahans, :sasarans
  end
end
