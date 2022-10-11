class AddBaselineDataToGenders < ActiveRecord::Migration[6.1]
  def change
    add_column :genders, :penerima_manfaat, :string
    add_column :genders, :sasaran_subkegiatan, :string
  end
end
