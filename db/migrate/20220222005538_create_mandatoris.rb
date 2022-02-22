class CreateMandatoris < ActiveRecord::Migration[6.1]
  def change
    create_table :mandatoris do |t|
      t.string :usulan
      t.string :peraturan_terkait

      t.timestamps
    end
  end
end
