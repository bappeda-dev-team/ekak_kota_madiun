json.extract! data_dukung, :id, :nama_data, :keterangan, :created_at, :updated_at
json.url data_dukung_url(data_dukung, format: :json)
