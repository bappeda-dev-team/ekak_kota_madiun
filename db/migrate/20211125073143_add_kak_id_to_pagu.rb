class AddKakIdToPagu < ActiveRecord::Migration[6.1]
  def change
    add_reference :pagus, :kak, index: true
  end
end
