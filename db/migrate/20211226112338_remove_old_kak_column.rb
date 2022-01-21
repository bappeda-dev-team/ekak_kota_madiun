class RemoveOldKakColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :kaks, :penerima_manfaat, :string
    remove_column :kaks, :data_terpilah, :text
    remove_column :kaks, :akses, :text
    remove_column :kaks, :partisipasi, :text
    remove_column :kaks, :kontrol, :text
    remove_column :kaks, :manfaat, :text
    remove_column :kaks, :penyebab_internal, :text
    remove_column :kaks, :penyebab_external, :text
    remove_column :kaks, :permasalahan_umum, :text
    remove_column :kaks, :permasalahan_gender, :text
    remove_column :kaks, :resiko, :text
    remove_column :kaks, :lokasi_pelaksanaan, :string
    remove_reference :kaks, :pk
  end
end
