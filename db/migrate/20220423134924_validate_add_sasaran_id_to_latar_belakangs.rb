class ValidateAddSasaranIdToLatarBelakangs < ActiveRecord::Migration[6.1]
  def change
    validate_foreign_key :latar_belakangs, :sasarans
  end
end
