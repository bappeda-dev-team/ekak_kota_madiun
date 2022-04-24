class ValidateAddForeignKeyToSasaranstematik < ActiveRecord::Migration[6.1]
  def change
    validate_foreign_key :sasarans, :subkegiatan_tematiks
  end
end
