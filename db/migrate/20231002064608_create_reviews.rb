class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.string :keterangan
      t.string :reviewable_type
      t.bigint :reviewable_id
      t.bigint :reviewer_id
      t.string :status
      t.jsonb :metadata

      t.timestamps
    end
  end
end
