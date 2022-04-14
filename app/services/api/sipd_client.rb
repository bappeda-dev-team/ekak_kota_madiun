module Api
  class SipdClient
    require 'http'
    require 'oj'

    URL = 'http://10.11.15.120:8888'.freeze
    H = HTTP.accept(:json)

    attr_accessor :id_sipd, :bulan, :tahun

    def initialize(_id_sipd, _tahun)
      # TODO: dynamic assign this later
      @id_sipd = '474'
      @tahun = 2022
    end

    def data_master_program
      request = request_master_program
      request_data_master_program(request)
    end

    def detail_master_program(id_program)
      request = request_detail_master_program(id_program)
      update_detail_master_program(request)
    end

    def gabung_data(program, id_gabung)
      id_program = program.collect { |prg| prg[:id_program] }
      detail_program = id_program.map { |id| detail_master_program(id) }.flatten
      flat_jajal = program << detail_program
      flat_jajal.flatten.group_by { |id| id[id_gabung] }.map { |_k, v| v.reduce(:merge) }
    end

    def list_opd
      response = H.get("#{URL}/list_opd_get/109").to_s
      result = JSON.parse(response, object_class: OpenStruct)
      result.data
    end

    def sub_kegiatan_detail
      response = H.get("#{URL}/get_komponen_all/109?tahun=#{tahun}&id_sub_skpd=#{id_sipd}")
      response.parse['data']
    end

    private

    def request_master_program
      H.get("#{URL}/master_program/109")
    end

    def request_detail_master_program(id_program)
      H.get("#{URL}/indikator_per_program/109/#{id_program}")
    end

    def request_data_master_program(response)
      data = Oj.load(response.body)
      programs = data['data']
      data_program = []
      programs.select! { |prg| prg['tahun'] == 2023 }
      programs.each do |program|
        id_program = program['id_program']
        tahun = program['tahun']
        kode_program = program['kode_program']
        nama_program = program['nama_program']
        id_unik = program['id_unik']
        data_program << { id_program: id_program, tahun: tahun, kode_program: kode_program, nama_program: nama_program,
                          id_unik: id_unik }
      end
      data_program
    end

    def update_detail_master_program(response)
      data = Oj.load(response.body)
      program_details = data['data']
      detail_program = []
      program_details.each do |program_detail|
        id_program = program_detail['id_program']
        indikator = program_detail['indikator']
        satuan = program_detail['satuan']
        target = program_detail['target_4']
        nama_urusan = program_detail['nama_urusan']
        nama_bidang_urusan = program_detail['nama_bidang_urusan']
        detail_program << { id_program: id_program, indikator: indikator, satuan: satuan,
                            target: target, nama_urusan: nama_urusan, nama_bidang_urusan: nama_bidang_urusan }
      end
      detail_program
    end
  end
end
