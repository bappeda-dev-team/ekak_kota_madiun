class CreateTematikSasarans < ActiveRecord::Migration[6.1]
  def up
    create_table :tematik_sasarans do |t|
      t.references :sasaran, foreign_key: true
      t.references :subkegiatan_tematik, foreign_key: true
      
      t.timestamps
    end
    # populate join table with existing data
    puts "populating tematik_sasarans"
    Sasaran.all.each do |sasaran|
      puts "#{sasaran.sasaran_kinerja} is being added to the sasarans_authors table"
      TematikSasaran.create(sasaran_id: sasaran.id, subkegiatan_tematik: sasaran.subkegiatan_tematik)
      puts "There are #{TematikSasaran.count} sasarans_tematiks records"
    end
    # remove obsolete column
    puts "removing old association"
    remove_foreign_key :sasarans, :subkegiatan_tematiks, column: :subkegiatan_tematik_id
    safety_assured { remove_column :sasarans, :subkegiatan_tematik_id, :bigint, foreign_key: true }
  end

  def down
    add_column :sasarans, :subkegiatan_tematik_id, :bigint, foreign_key: true, null: true
    add_foreign_key :sasarans, :subkegiatan_tematiks, column: :subkegiatan_tematik_id, primary_key: :id, validate: false
    Sasaran.reset_column_information
    TematikSasaran.all.each do |tematik_sasaran|
      Sasaran.find(tematik_sasaran.sasaran_id).update_attribute(subkegiatan_tematik_id: tematik_sasaran.subkegiatan_tematik_id)
    end
    drop_table :tematik_sasarans
  end
end
