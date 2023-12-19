class CreateIndikatorsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :indikators_users do |t|
      t.belongs_to :indikator
      t.belongs_to :user

      t.timestamps
    end
  end
end
