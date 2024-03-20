class AddTimestampToIndikators < ActiveRecord::Migration[6.1]
  def change
    add_timestamps :indikators, null: false, default: -> { 'NOW()' }
  end
end
