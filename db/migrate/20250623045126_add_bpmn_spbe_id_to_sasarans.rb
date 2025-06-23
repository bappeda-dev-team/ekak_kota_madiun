class AddBpmnSpbeIdToSasarans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  def change
    add_reference_concurrently :sasarans, :bpmn_spbe, null: true, foreign_key: true
  end
end
