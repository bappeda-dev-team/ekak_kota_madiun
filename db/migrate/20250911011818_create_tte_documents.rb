class CreateTteDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :tte_documents do |t|
      t.string :status, default: 'diproses'
      t.string :doc_url, null: true
      t.string :tte_doc_url, null: true
      t.string :error_message, null: true
      t.string :kode_opd
      t.string :tahun, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
