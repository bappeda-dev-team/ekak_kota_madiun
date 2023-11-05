# frozen_string_literal: true

module Api
  # Client for SKP API
  class SkpClient
    require 'http'
    require 'oj'
    URL = 'https://skp.madiunkota.go.id/api'
    H = HTTP.accept(:json)
    attr_accessor :kode_opd, :bulan, :tahun, :nip_asn

    USERNAME = 'bappeda'
    PASSWORD = 'bapp7832KH'

    def initialize(kode_opd, tahun, bulan = '', nip_asn = '')
      # @kode_opd = '2.16.2.20.2.21.04.0000'
      # @tahun = 2022
      # @bulan = 2
      # tipe_asn = 'pns' | 'non_pns'
      @kode_opd = kode_opd
      @tahun = tahun
      @bulan = bulan
      @nip_asn = nip_asn
    end

    def update_pegawai
      request = H.post("#{URL}/data-pegawai-all/#{@kode_opd}/#{@tahun}/#{@bulan}",
                       form: { username: USERNAME, password: PASSWORD })
      update_data_pegawai(request)
    end

    def sync_jabatan
      eselon = H.post("#{URL}/data-jabatan/all/eselon/#{@tahun}",
                      form: { username: USERNAME, password: PASSWORD })
      update_jabatan_eselon(eselon)
      noneselon = H.post("#{URL}/data-jabatan/all/noneselon/#{@tahun}",
                         form: { username: USERNAME, password: PASSWORD })
      update_jabatan_eselon(noneselon)
    end

    private

    def update_jabatan_eselon(response) # rubocop:disable Metrics
      data = JSON.parse(response.body)
      jabatans = data['data']
      jabatans.each do |jabatan|
        data_jabatan = {
          index: jabatan['index'],
          kelas_jabatan: jabatan['kelas_jabatan'],
          id_jabatan: jabatan['id'],
          kode_opd: jabatan['kode_opd'],
          nama_jabatan: jabatan['nama_jabatan'],
          nilai_jabatan: jabatan['nilai_jabatan'],
          tahun: jabatan['tahun'],
          tipe: jabatan['tipe']
        }
        jabatan_record = Jabatan.find_by(
          id_jabatan: jabatan['id'],
          tahun: @tahun,
          kode_opd: jabatan['kode_opd']
        )
        if jabatan_record.nil?
          Jabatan.create(data_jabatan)
        else
          jabatan_record.update(data_jabatan)
        end
      end
    end

    def update_data_pegawai(response) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      kode_opd = Opd.find_by(kode_unik_opd: @kode_opd).kode_opd || '0'
      data = JSON.parse(response.body)
      pegawais = data['data']
      data_pegawais = []
      pegawais.each do |pegawai|
        email = "#{pegawai['nip']}@madiunkota.go.id"
        nip = pegawai['nip']
        nama = pegawai['nama']
        jabatan = pegawai['jabatan']
        eselon = pegawai['eselon']
        pangkat = pegawai['pangkat']
        nama_pangkat = pegawai['nama_pangkat']
        id_bidang = pegawai['id_bidang']
        nama_bidang = pegawai['nama_bidang']
        password = User.new(password: 123_456).encrypted_password
        data_pegawais << { kode_opd: kode_opd, nik: nip, nama: nama, jabatan: jabatan,
                           eselon: eselon, pangkat: pangkat, nama_pangkat: nama_pangkat,
                           id_bidang: id_bidang, nama_bidang: nama_bidang, email: email,
                           encrypted_password: password,
                           created_at: Time.now, updated_at: Time.now }
      end
      data_pegawais.each do |data_p|
        User.upsert(data_p, unique_by: :nik)
      end
    end
  end
end
