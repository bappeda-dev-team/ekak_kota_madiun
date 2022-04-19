module Api
  class SipdClient
    require 'http'
    require 'oj'

    URL = 'http://10.11.15.120:8888'.freeze
    H = HTTP.accept(:json)

    attr_accessor :id_sipd, :tahun, :id_opd

    def initialize(id_sipd, tahun, id_opd)
      # TODO: dynamic assign this later
      @id_sipd = id_sipd
      @tahun = tahun || 2022
      @id_opd = id_opd
    end

    def data_subkegiatan_all
      request = request_sub_kegiatan_all(@tahun, @id_sipd)
      proses_data_subkegiatan(request)
    end

    def data_master_program
      request = request_master_program
      proses_data_master_program(request)
    end

    def detail_master_program(id_program)
      request = request_detail_master_program(id_program)
      proses_detail_master_program(request)
    end

    def gabung_data(program, id_gabung)
      id_program = program.collect { |prg| prg[:id_program] }
      detail_program = id_program.map { |id| detail_master_program(id) }.flatten
      flat_jajal = program << detail_program
      flat_jajal.flatten.group_by { |id| id[id_gabung] }.map { |_k, v| v.reduce(:merge) }
      Program.upsert_all(flat_jajal, unique_by: [:id_program])
    end

    def list_opd
      response = H.get("#{URL}/list_opd_get/109").to_s
      result = JSON.parse(response, object_class: OpenStruct)
      result.data
    end

    private

    def request_sub_kegiatan_all(tahun, id_sipd)
      H.get("#{URL}/get_komponen_all/109?tahun=#{tahun}&id_sub_skpd=#{id_sipd}")
    end

    def request_master_program
      H.get("#{URL}/master_program/109")
    end

    def request_detail_master_program(id_program)
      H.get("#{URL}/indikator_per_program/109/#{id_program}")
    end

    def proses_data_master_program(response)
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

    def proses_detail_master_program(response)
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

    def proses_data_subkegiatan(response)
      data = Oj.load(response.body)
      data_detail = data['data']
     jajals = data_detail.uniq { |el| el['kode_sub_giat'] }
      data_subkegiatan = []
      jajals.each do |sub|
        id_rinci_sub_bl = sub['id_rinci_sub_bl']
        kode_sub_skpd = sub["kode_sub_skpd"]
        id_unit = sub['id_unit']
        kode_urusan = sub['kode_urusan']
        nama_urusan = sub['nama_urusan']
        kode_bidang_urusan = sub['kode_bidang_urusan']
        nama_bidang_urusan = sub['nama_bidang_urusan']
        id_program_sipd = sub['id_program']
        kode_program = sub['kode_program']
        nama_program = sub['nama_program']
        kode_giat = sub['kode_giat']
        nama_kegiatan = sub['nama_giat']
        kode_sub_giat = sub['kode_sub_giat']
        nama_sub_giat = sub['nama_sub_giat']
        pagu = sub['pagu']
        data_subkegiatan << {
          identifier_belanja: id_rinci_sub_bl,
          id_unit: id_unit,
          kode_urusan: kode_urusan,
          nama_urusan: nama_urusan,
          kode_bidang_urusan: kode_bidang_urusan,
          nama_bidang_urusan: nama_bidang_urusan,
          id_program_sipd: id_program_sipd,
          kode_program: kode_program,
          nama_program: nama_program,
          kode_giat: kode_giat,
          nama_kegiatan: nama_kegiatan,
          kode_sub_giat: kode_sub_giat,
          nama_subkegiatan: nama_sub_giat,
          pagu: pagu,
          created_at: Time.now, 
          updated_at: Time.now,
          kode_opd: @id_opd # warning hard coded 
        }
      end
      ProgramKegiatan.insert_all(data_subkegiatan)
    end
  end
end
