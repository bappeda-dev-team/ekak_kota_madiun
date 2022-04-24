class ValidateAddReferenceSasaranOnDasarHukums < ActiveRecord::Migration[6.1]
  def change
    validate_foreign_key :dasar_hukums, :sasarans
  end
end
