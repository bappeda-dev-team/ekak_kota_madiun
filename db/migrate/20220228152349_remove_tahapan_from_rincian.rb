class RemoveTahapanFromRincian < ActiveRecord::Migration[6.1]
  def change
    remove_reference :tahapans, :rincian
  end
end
