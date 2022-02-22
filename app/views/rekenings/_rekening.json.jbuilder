json.extract! rekening, :id, :kode_rekening, :jenis_rekening, :created_at, :updated_at
json.url rekening_url(rekening, format: :json)
