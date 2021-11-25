class AddPkIdToKak < ActiveRecord::Migration[6.1]
  def change
    add_reference :kaks, :pk, index: true
  end
end
