class AddDapatDigunakanPdLainToBpmnSpbes < ActiveRecord::Migration[6.1]
  def change
    add_column :bpmn_spbes, :dapat_digunakan_pd_lain, :boolean, default: false
  end
end
