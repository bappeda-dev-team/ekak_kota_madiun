# Sipd Master Client
# Help Pulling Master Data from SIPD
# that not shown in basic sipd_client
# hide this from user, and only fetch from this, if the subkegiatan not found
module Api
  class SipdMasterClient
    require 'http'
    require 'oj'

    URL = 'http://10.11.15.120:8888'.freeze
    H = HTTP.accept(:json)

    attr_accessor :tahun, :id

    def initialize(tahun: Date.today.year, id: nil)
      @tahun = tahun
      @id = id
    end

    def sync_master_program
      request = url_master_program
      proses_data_master_program(response: request)
    end

    def sync_master_kegiatan
      request = url_master_kegiatan
      proses_data_master_kegiatan(response: request)
    end

    def sync_master_subkegiatan
      request = url_master_subkegiatan(id_giat: @id)
      proses_data_master_subkegiatan(response: request)
    end

    def sync_master_output_kegiatans
      request = url_output_belanja(tahun: @tahun)
      proses_data_master_output_kegiatans(response: request)
    end

    private

    def url_master_program
      H.get("#{URL}/master_program/109")
    end

    def url_master_kegiatan
      H.get("#{URL}/master_kegiatan/109")
    end

    def url_master_subkegiatan(id_giat:)
      H.get("#{URL}/master_sub_kegiatan/109?id_giat=#{id_giat}")
    end

    def url_output_belanja(tahun:)
      H.get("#{URL}/output_bl/109?tahun=#{tahun}") # this will load 1000 records
    end

    # data processing
    def proses_data_master_program(response:)
      data = Oj.load(response.body)
      programs = data['data']
      data_program = []
      programs.each do |program|
        data_program << {
          id_program_sipd: program['id_program'],
          id_urusan: program['id_urusan'],
          id_bidang_urusan: program['id_bidang_urusan'],
          kode_program: program['kode_program'],
          nama_program: program['nama_program'],
          no_program: program['no_program'],
          tahun: program['tahun'],
          id_unik_sipd: program['id_unik'],
          created_at: Time.now,
          updated_at: Time.now
        }
      end
      Master::Program.upsert_all(data_program, unique_by: :id_unik_sipd)
    end

    def proses_data_master_kegiatan(response:)
      data = Oj.load(response.body)
      kegiatans = data['data']
      data_kegiatan = []
      kegiatans.each do |kegiatan|
        data_kegiatan << {
          id_kegiatan_sipd: kegiatan['id_giat'],
          id_urusan: kegiatan['id_urusan'],
          id_bidang_urusan: kegiatan['id_bidang_urusan'],
          kode_giat: kegiatan['kode_giat'],
          nama_giat: kegiatan['nama_giat'],
          no_giat: kegiatan['no_giat'],
          tahun: kegiatan['tahun'],
          id_unik_sipd: kegiatan['id_unik'].to_s + '-' + kegiatan['tahun'].to_s,
          id_program: kegiatan['id_program'],
          created_at: Time.now,
          updated_at: Time.now
        }
      end
      Master::Kegiatan.upsert_all(data_kegiatan, unique_by: :id_unik_sipd)
    end

    def proses_data_master_subkegiatan(response:)
      data = Oj.load(response.body)
      subkegiatans = data['data']
      data_subkegiatan = []
      subkegiatans.each do |subkegiatan|
        data_subkegiatan << {
          id_sub_kegiatan_sipd: subkegiatan['id_sub_giat'],
          id_urusan: subkegiatan['id_urusan'],
          id_bidang_urusan: subkegiatan['id_bidang_urusan'],
          kode_sub_kegiatan: subkegiatan['kode_sub_giat'],
          nama_sub_kegiatan: subkegiatan['nama_sub_giat'],
          no_sub_kegiatan: subkegiatan['no_sub_giat'],
          tahun: subkegiatan['tahun'],
          id_unik_sipd: subkegiatan['id_unik'],
          id_program: subkegiatan['id_program'],
          id_kegiatan: subkegiatan['id_giat'],
          created_at: Time.now,
          updated_at: Time.now
        }
      end
      Master::Subkegiatan.upsert_all(data_subkegiatan, unique_by: :id_unik_sipd)
    end

    def proses_data_master_output_kegiatans(response:)
      data = Oj.load(response.body)
      output_kegiatans = data['data']
      data_output = []
      output_kegiatans.each do |output|
        data_output << {
          id_output_bl: output['id_output_bl'],
          id_bl: output['id_bl'],
          id_skpd: output['id_skpd'],
          id_sub_skpd: output['id_sub_skpd'],
          id_program: output['id_program'],
          id_kegiatan: output['id_giat'],
          id_sub_kegiatan: output['id_sub_giat'],
          indikator_kegiatan: output['tolak_ukur'],
          target_kegiatan: output['target'],
          satuan_kegiatan: output['satuan'],
          indikator_sub_kegiatan: output['tolok_ukur_sub'],
          target_sub_kegiatan: output['target_sub'],
          satuan_sub_kegiatan: output['satuan_sub'],
          tahun: output['tahun'],
          created_at: Time.now,
          updated_at: Time.now
        }
      end
      Master::OutputKegiatan.upsert_all(data_output, unique_by: :id_output_bl)
    end
  end
end
