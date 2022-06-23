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

    private

    def url_master_program
      H.get("#{URL}/master_program/109")
    end

    def url_master_kegiatan
      H.get("#{URL}/master_program/109")
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
  end
end
