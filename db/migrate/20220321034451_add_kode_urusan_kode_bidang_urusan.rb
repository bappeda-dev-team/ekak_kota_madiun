class AddKodeUrusanKodeBidangUrusan < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :kode_urusan, :string
    add_column :opds, :kode_bidang_urusan, :string
  end
end
