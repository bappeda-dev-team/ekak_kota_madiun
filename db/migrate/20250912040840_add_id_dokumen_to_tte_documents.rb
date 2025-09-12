class AddIdDokumenToTteDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :tte_documents, :id_dokumen, :string
  end
end
