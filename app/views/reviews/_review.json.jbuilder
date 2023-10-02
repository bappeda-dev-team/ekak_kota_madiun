json.extract! review, :id, :keterangan, :reviewable_type, :reviewable_id, :reviewer_id, :status, :metadata, :created_at, :updated_at
json.url review_url(review, format: :json)
