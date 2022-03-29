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
      H.post("#{URL}/data-pegawai/#{kode_opd}/#{tahun}/#{bulan}",
             form: { username: USERNAME, password: PASSWORD })
    end

    def update_data_sasaran(response) # rubocop:disable Metrics/MethodLength
      data = Oj.load(response.body)
      pegawais = data['data']['data_pegawai']
      pegawais.reject! { |pe| pe['eselon'].match(/^(2|3)/) }
      data_sasaran = []
      data_renaksi = []
      pegawais.each do |pegawai|
        pegawai['list_rencana_kinerja'].each do |rencana|
          id_rencana = rencana['id']
          sasaran_kinerja = rencana['rencana_kerja']
          indikator_kinerja = rencana['list_indikator'][0]['iki']
          target = rencana['list_indikator'][0]['target']
          satuan = rencana['list_indikator'][0]['satuan']
          nip_asn = pegawai['nip']
          data_sasaran << { sasaran_kinerja: sasaran_kinerja, indikator_kinerja: indikator_kinerja, target: target,
                            satuan: satuan, nip_asn: nip_asn, id_rencana: id_rencana }
          rencana['list_rencana_aksi'].each do |rencana_aksi|
            id_rencana = rencana_aksi['id_rencana_kerja']
            tahapan = rencana_aksi['tahapan_kerja']
            id_rencana_aksi = rencana_aksi['id']
            data_renaksi << { tahapan: tahapan, id_rencana_aksi: id_rencana_aksi, id_rencana: id_rencana }
          end
        end
      end
      Sasaran.upsert_all(data_sasaran)
      Tahapan.upsert_all(data_renaksi)
    end

    def update_data_pegawai(response)
      kode_opd = Opd.find_by(kode_unik_opd: @kode_opd).kode_opd || '0'
      data = Oj.load(response.body)
      pegawais = data['data']
      pegawais.each do |pegawai|
        email = "#{pegawai[1]['nip']}@madiunkota.go.id"
        nip = pegawai[1]['nip']
        nama = pegawai[1]['nama']
        jabatan = pegawai[1]['jabatan']
        eselon = 'NON ESELON' # WARNING: Hardcoded
        User.create_or_find_by(nik: nip) do |u|
          u.nama = nama
          u.email = email
          u.jabatan = jabatan
          u.eselon = eselon
          u.kode_opd = kode_opd
          u.password = '123456'
        end
      end
    end
  end
end
