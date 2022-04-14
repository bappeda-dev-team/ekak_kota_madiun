class AddIdentifierBelanjaToProgramkegiatans < ActiveRecord::Migration[6.1]
  def change
    add_column :program_kegiatans, :identifier_belanja, :string
  end
end
