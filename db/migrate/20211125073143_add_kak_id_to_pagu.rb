class AddKakIdToPagu < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :pagus, :kak, index: true
  end
end
