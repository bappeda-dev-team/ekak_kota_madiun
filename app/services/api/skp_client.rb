# frozen_string_literal: true

module Api
  # Client for SKP API
  class SkpClient
    require 'http'
    require 'oj'
    URL = 'https://skp.madiunkota.go.id/api'
    H = HTTP.accept(:json)
    attr_accessor :kode_opd, :bulan, :tahun

    USERNAME = 'bappeda'
    PASSWORD = 'bapp7832KH'

    def initialize(kode_opd, tahun, bulan)
      # @kode_opd = '2.16.2.20.2.21.04.0000'
      # @tahun = 2022
      # @bulan = 2
      @kode_opd = kode_opd
      @tahun = tahun
      @bulan = bulan
    end

    def data_sasaran_asn_opd
      request_skp(kode_opd, tahun, bulan)
    end

    def data_pegawai
      request_pegawai(kode_opd, tahun, bulan)
    end

    def update_pegawai
      request = data_pegawai
      update_data_pegawai(request)
    end

    def update_sasaran
      request = data_sasaran_asn_opd
      update_data_sasaran(request)
    end

    private

    def request_skp(kode_opd, tahun, bulan)
      H.post("#{URL}/sasaran-kinerja-pegawai/#{kode_opd}/#{tahun}/#{bulan}",
             form: { username: USERNAME, password: PASSWORD })
    end

    def request_pegawai(kode_opd, tahun, bulan)
      H.post("#{URL}/data-pegawai-all/#{kode_opd}/#{tahun}/#{bulan}",
             form: { username: USERNAME, password: PASSWORD })
    end

    def update_data_sasaran(response) # rubocop:disable Metrics/MethodLength
      data = Oj.load(response.body)
      data_opd = data['data']['data_opd']
      pegawais = data['data']['data_pegawai']
      pegawais.reject! { |pe| pe['eselon'].match(/^(2|3)/) }
      data_sasaran = []
      data_indikator = []
      data_tahapan = []
      data_renaksi = []
      pegawais.each do |pegawai|
        next unless pegawai['list_rencana_kinerja']

        pegawai['list_rencana_kinerja'].each do |rencana|
          id_rencana = rencana['id']
          sasaran_kinerja = rencana['rencana_kerja']
          nip_asn = pegawai['nip']
          data_sasaran << { sasaran_kinerja: sasaran_kinerja,
                            indikator_kinerja: nil, target: nil, satuan: nil,
                            nip_asn: nip_asn, id_rencana: id_rencana,
                            created_at: Time.now, updated_at: Time.now }
          next unless rencana['list_indikator']

          rencana['list_indikator'].each do |indikator|
            indikator_kinerja = indikator['iki']
            target = indikator['target']
            satuan = indikator['satuan']
            aspek = indikator['aspek']
            id_indikator = indikator['id']
            data_indikator << { indikator_kinerja: indikator_kinerja,
                                target: target, satuan: satuan,
                                id_indikator: id_indikator,
                                aspek: aspek, sasaran_id: id_rencana,
                                created_at: Time.now, updated_at: Time.now }
          end
          next unless rencana['list_rencana_aksi']

          rencana['list_rencana_aksi'].each do |rencana_aksi|
            id_rencana = rencana_aksi['id_rencana_kerja']
            tahapan_kerja = rencana_aksi['tahapan_kerja']
            id_rencana_aksi = rencana_aksi['id']
            data_tahapan << { tahapan_kerja: tahapan_kerja,
                              id_rencana_aksi: id_rencana_aksi,
                              id_rencana: id_rencana,
                              created_at: Time.now, updated_at: Time.now }
            rencana_aksi['list_bulan'].each do |aksi|
              bulan = aksi['bulan']
              target = aksi['target']
              id_rencana_aksi = aksi['id_tahapan']
              id_aksi_bulan = aksi['id']
              data_renaksi << { bulan: bulan, target: target.to_i,
                                id_rencana_aksi: id_rencana_aksi,
                                id_aksi_bulan: id_aksi_bulan,
                                created_at: Time.now, updated_at: Time.now }
            end
          end
        end
      end
      kode_opd = data_opd['id']
      kode_unik_opd = data_opd['unit_id']
      id_opd_skp = data_opd['id_sipd']
      insert_to_opd = { kode_opd: kode_opd, kode_unik_opd: kode_unik_opd, id_opd_skp: id_opd_skp}
      opd = Opd.find_by(kode_opd: kode_opd)
      opd.update(insert_to_opd)
      data_renaksi.reject! { |renaksi| renaksi[:target].zero? }
      Sasaran.upsert_all(data_sasaran, unique_by: :id_rencana)
      IndikatorSasaran.upsert_all(data_indikator, unique_by: :id_indikator)
      Tahapan.upsert_all(data_tahapan, unique_by: :id_rencana_aksi)
      Aksi.upsert_all(data_renaksi, unique_by: :id_aksi_bulan)
    end

    def update_data_pegawai(response)
      kode_opd = Opd.find_by(kode_unik_opd: @kode_opd).kode_opd || '0'
      data = Oj.load(response.body)
      pegawais = data['data']
      pegawais.each do |pegawai|
        email = "#{pegawai['nip']}@madiunkota.go.id"
        nip = pegawai['nip']
        nama = pegawai['nama']
        jabatan = pegawai['jabatan']
        eselon = pegawai['eselon']
        pangkat = pegawai['pangkat']
        nama_pangkat = pegawai['nama_pangkat']
        User.create_or_find_by(nik: nip) do |u|
          u.nama = nama
          u.email = email
          u.jabatan = jabatan
          u.pangkat = pangkat
          u.nama_pangkat = nama_pangkat
          u.eselon = eselon
          u.kode_opd = kode_opd
          u.password = '123456'
        end
      end
    end
  end
end
