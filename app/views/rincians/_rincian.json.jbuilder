json.extract! rincian, :id, :data_terpilah, :kesenjangan_id, :penyebab_internal, :penyebab_external,
              :permasalahan_umum, :permasalahan_gender, :resiko, :lokasi_pelaksanaan, :tahapan_id, :created_at, :updated_at
json.url rincian_url(rincian, format: :json)
