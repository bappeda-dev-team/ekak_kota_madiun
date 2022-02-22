class CreateRekenings < ActiveRecord::Migration[6.1]
  def change
    create_table :rekenings do |t|
      t.string :kode_rekening
      t.string :jenis_rekening

      t.timestamps
    end
  end
end
