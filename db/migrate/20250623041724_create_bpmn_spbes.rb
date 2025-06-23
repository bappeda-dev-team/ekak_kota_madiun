class CreateBpmnSpbes < ActiveRecord::Migration[6.1]
  def change
    create_table :bpmn_spbes do |t|
      t.string :nama_bpmn
      t.string :kode_opd
      t.string :tahun
      t.string :keterangan

      t.timestamps
    end
  end
end
