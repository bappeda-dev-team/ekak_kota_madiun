# frozen_string_literal: true

module Api
  class SipkdClient
    require 'http'
    require 'oj'
    URL = 'https://sipkd2.madiunkota.go.id/data'
    H = HTTP.accept(:json)
    attr_accessor :kode_unik_opd, :tahun, :bulan, :kode_opd, :tahun_asli

    def initialize(kode_unik_opd, tahun, bulan, kode_opd, tahun_asli)
      @kode_unik_opd = kode_unik_opd
      @tahun = tahun
      @bulan = bulan
      @kode_opd = kode_opd
      @tahun_asli = tahun_asli
    end

    def sync_penetapan
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = H.get("#{URL}/#{@tahun}/serapan_belanja/opd",
                      params: { bulan: @bulan, opd: @kode_unik_opd },
                      ssl_context: ctx)
      update_pagu_penetapan(request)
    end

    private

    def update_pagu_penetapan(response)
      # data = Oj.load(response.body)
      data = JSON.parse(response.body)
      pagu_penetapans = data['data']
      pagu_penetapans.each do |pagu|
        data_pagu = {
          jenis: 'Penetapan',
          sub_jenis: 'Renja',
          tahun: @tahun_asli,
          kode_opd: @kode_opd,
          kode: pagu['unit_kode'],
          anggaran: pagu['pagu'],
          kode_belanja: pagu['sub_kegiatan_kode'],
          kode_sub_belanja: pagu['sub_rincian_obyek_kode'],
          keterangan: pagu['sub_rincian_obyek_nama'],
          created_at: Time.now, updated_at: Time.now
        }
        PaguAnggaran.insert(data_pagu)
      end
    end
  end
end
