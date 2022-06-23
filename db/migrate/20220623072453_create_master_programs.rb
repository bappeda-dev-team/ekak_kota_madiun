class CreateMasterPrograms < ActiveRecord::Migration[6.1]
  def change
    create_table :master_programs do |t|
      t.string :id_program_sipd, null: true
      t.string :kode_program, null: true
      t.string :tahun, default: Date.today.year
      t.string :id_urusan, null: true
      t.string :id_bidang_urusan, null: true
      t.string :nama_program, default: '-'
      t.string :no_program, null: true
      t.string :id_unik_sipd, null: false, unique: true
      t.timestamps

      t.index :id_unik_sipd, unique: true
    end
  end
end
