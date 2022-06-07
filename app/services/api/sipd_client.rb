module Api
  class SipdClient
    require 'http'
    require 'oj'

    URL = 'http://10.11.15.120:8888'.freeze
    H = HTTP.accept(:json)

    attr_accessor :id_sipd, :tahun, :id_opd, :id_program

    def initialize(id_sipd: nil, tahun: nil, id_opd: nil, id_program: nil)
      # TODO: dynamic assign this later
      @id_sipd = id_sipd
      @tahun = tahun || 2022
      @id_opd = id_opd
      @id_program = id_program
    end

    def data_subkegiatan_all
      request = request_sub_kegiatan_all(@tahun, @id_sipd)
      proses_data_subkegiatan(request)
    end

    def opd_master
      request = request_opd_master(tahun: @tahun)
      proses_data_master_opd(request)
    end

    def data_master_program
      request = request_master_program
      proses_data_master_program(request)
    end

    def detail_master_program
      request = request_detail_master_program(@id_program)
      proses_detail_master_program(request)
    end

    def detail_kegiatan_lama
      request = request_indikator_kegiatan(id_kegiatan: @id_program, id_opd: @id_sipd)
      proses_detail_kegiatan_lama(request)
    end

    def detail_master_kegiatan
      request = request_subkegiatan_opd(tahun: @tahun, id_opd: @id_sipd)
      proses_detail_master_kegiatan(request)
    end

    def detail_master_subkegiatan
      response = request_subkegiatan_opd(tahun: @tahun, id_opd: @id_sipd)
      proses_detail_master_subkegiatan(response)
    end

    def musrenbang_master
      response = request_musrenbang_data(@tahun)
      proses_data_musrenbang(response)
    end

    def pokpir_master
      response = request_pokpir_data(@tahun)
      proses_data_pokir(response)
    end

    def kamus_usulan_master
      response = request_kamus_usulan_data(@tahun)
      proses_data_kamus_usulan(response)
    end

    def gabung_data(program, id_gabung)
      id_program = program.collect { |prg| prg[:id_program] }
      detail_program = id_program.map { |id| detail_master_program(id) }.flatten
      flat_jajal = program << detail_program
      flat_jajal.flatten.group_by { |id| id[id_gabung] }.map { |_k, v| v.reduce(:merge) }
      Program.upsert_all(flat_jajal, unique_by: [:id_program])
    end

    def list_opd
      response = request_opd_master(tahun: @tahun)
      result = JSON.parse(response, object_class: OpenStruct)
      result.data
    end

    def subkegiatan_opd
      response = request_subkegiatan_opd(tahun: @tahun, id_opd: @id_sipd)
      proses_data_subkegiatan_opd(response)
    end

    private
# TODO: buat fungsi get datanya
    def request_opd_master(tahun:)
      H.get("#{URL}/list_opd_get/109?tahun=#{tahun}")
    end

    def request_subkegiatan_opd(tahun:, id_opd:)
      H.get("#{URL}/get_sub_kegiatan_opd/109?id_giat=&id_skpd=#{id_opd}&tahun=#{tahun}")
    end

    def request_indikator_program(id_program:)
      H.get("#{URL}/indikator_per_program/109/#{id_program}")
    end

    def request_indikator_kegiatan(id_kegiatan:, id_opd:)
      H.get("#{URL}/indikator_per_kegiatan/109/#{id_opd}/#{id_kegiatan}")
    end
# TODO Depreceate this thing
    def request_sub_kegiatan_all(tahun, id_sipd)
      H.get("#{URL}/get_komponen_all/109?id_sub_giat=&id_sub_skpd=#{id_sipd}&tahun=#{tahun}")
    end

    def request_master_program
      H.get("#{URL}/master_program/109")
    end

    def request_detail_master_program(id_program)
      H.get("#{URL}/indikator_per_program/109/#{id_program}")
    end

    def request_musrenbang_data(tahun)
      H.get("#{URL}/usulan_musrenbang/109?tahun=#{tahun}")
    end

    def request_pokpir_data(tahun)
      H.get("#{URL}/usul_reses/109?tahun=#{tahun}")
    end

    def request_kamus_usulan_data(tahun)
      H.get("#{URL}/kamus_usulan_musrenbang/109?tahun=#{tahun}")
    end

    def proses_data_master_opd(response)
      data = Oj.load(response.body)
      opds = data['data']
      data_opd = []
      opds.each do |opd|
        data_opd << {
          tahun: opd['tahun'],
          id_daerah: opd['id_daerah'],
          id_opd_skp: opd['id_skpd'],
          nama_opd: opd['nama_skpd'],
          kode_unik_opd: opd['kode_skpd'],
          nama_kepala: opd['nama_kepala'],
          nip_kepala: opd['nip_kepala'],
          status_kepala: opd['status_kepala'],
          lembaga_id: Lembaga.first.id,
          created_at: Time.now,
          updated_at: Time.now
        }
      end
      Opd.upsert_all(data_opd, unique_by: :kode_unik_opd)
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

    # Update Program
    def proses_detail_master_program(response)
      data = Oj.load(response.body)
      program_details = data['data']
      if program_details.empty?
        indikator_program = ''
        target_program = ''
        satuan_target_program = ''
      else
        indikator_program = program_details.first['indikator']
        target_program = program_details.first['target_3'] # target_1 asumsi tahun 2020, 2021 target_2, 2022 target_3
        satuan_target_program = program_details.first['satuan']
      end
      ProgramKegiatan.where(id_program_sipd: @id_program)
                     .update_all(indikator_program: indikator_program,
                                 target_program: target_program,
                                 satuan_target_program: satuan_target_program)
    end

    # Update Kegiatans
    def proses_detail_kegiatan_lama(response)
      data = Oj.load(response.body)
      kegiatan_details = data['data']
      if kegiatan_details.empty?
        indikator_kinerja = ''
        target = ''
        satuan = ''
      else
        indikator_kinerja = kegiatan_details.first['indikator_keg']
        target = kegiatan_details.first['target_keg'] # indikator_per_kegiatan
        satuan = kegiatan_details.first['satuan_keg']
      end
      ProgramKegiatan.where(id_giat: @id_program)
                     .update_all(indikator_kinerja: indikator_kinerja,
                                 target: target,
                                 satuan: satuan)
    end

    # Update Kegiatan irisan dari subkegiatan
    def proses_detail_master_kegiatan(response)
      data = Oj.load(response.body)
      kegiatans = data['data']
      # list_sub_kegiatan = ProgramKegiatan.where(id_unit: @id_sipd).pluck(:id_sub_giat)
      # kegiatans.select! { |sub| list_sub_kegiatan.include?(sub['id_sub_giat']) }
      kegiatans.each do |giat|
        target_kegiatan = giat['outcome_giat2']
        target_kegiatan_cadangan = giat['outcome_giat1']
        if target_kegiatan.any?
          indikator_kinerja = target_kegiatan.first['indikator_keg']
          target = target_kegiatan.first['target_keg']
          satuan = target_kegiatan.first['satuan_keg']
        elsif target_kegiatan_cadangan.any?
          indikator_kinerja = target_kegiatan_cadangan.first['indikator_keg']
          target = target_kegiatan_cadangan.first['target_keg']
          satuan = target_kegiatan_cadangan.first['satuan_keg']
        else
          indikator_kinerja = ''
          target = ''
          satuan = ''
        end
        ProgramKegiatan.where(id_giat: giat['id_giat'])
                       .update_all(indikator_kinerja: indikator_kinerja, target: target,
                                   satuan: satuan)
      end
    end

    # Update subkegiatan indikator dll
    def proses_detail_master_subkegiatan(response)
      data = Oj.load(response.body)
      subkegiatan_details = data['data']
      # list_sub_kegiatan = ProgramKegiatan.where(id_unit: @id_sipd).pluck(:id_sub_giat)
      # subkegiatan_details.select! { |sub| list_sub_kegiatan.include?(sub['id_sub_giat']) }
      subkegiatan_details.each do |sub_giat|
        indikator_sub = sub_giat['indikator_sub']
        target_sub = sub_giat['target_sub']
        satuan_sub = sub_giat['satuan_sub']
        ProgramKegiatan.where(id_sub_giat: sub_giat['id_sub_giat'])
                       .update_all(indikator_subkegiatan: indikator_sub, target_subkegiatan: target_sub,
                                   satuan_target_subkegiatan: satuan_sub)
      end
    end

    # ref belanja, depreciated soon, use proses_data_subkegiatan_opd
    def proses_data_subkegiatan(response)
      data = Oj.load(response.body)
      data_detail = data['data']
      jajals = data_detail.uniq { |el| el['kode_sub_giat'] }
      data_subkegiatan = []
      jajals.each do |sub|
        id_rinci_sub_bl = sub['id_rinci_sub_bl']
        tahun = sub['tahun']
        kode_skpd = sub["kode_skpd"]
        kode_sub_skpd = sub["kode_sub_skpd"]
        id_unit = sub['id_unit']
        id_sub_unit = sub['id_sub_skpd']
        kode_urusan = sub['kode_urusan']
        nama_urusan = sub['nama_urusan']
        kode_bidang_urusan = sub['kode_bidang_urusan']
        nama_bidang_urusan = sub['nama_bidang_urusan']
        id_program_sipd = sub['id_program']
        kode_program = sub['kode_program']
        nama_program = sub['nama_program']
        id_giat = sub['id_giat']
        kode_giat = sub['kode_giat']
        nama_kegiatan = sub['nama_giat']
        id_sub_giat = sub['id_sub_giat']
        kode_sub_giat = sub['kode_sub_giat']
        nama_sub_giat = sub['nama_sub_giat']
        pagu = sub['pagu']
        data_subkegiatan << {
          identifier_belanja: id_rinci_sub_bl,
          tahun: tahun,
          kode_skpd: kode_skpd,
          kode_sub_skpd: kode_sub_skpd,
          id_unit: id_unit,
          id_sub_unit: id_sub_unit,
          kode_urusan: kode_urusan,
          nama_urusan: nama_urusan,
          kode_bidang_urusan: kode_bidang_urusan,
          nama_bidang_urusan: nama_bidang_urusan,
          id_program_sipd: id_program_sipd,
          kode_program: kode_program,
          nama_program: nama_program,
          id_giat: id_giat,
          kode_giat: kode_giat,
          nama_kegiatan: nama_kegiatan,
          id_sub_giat: id_sub_giat,
          kode_sub_giat: kode_sub_giat,
          nama_subkegiatan: nama_sub_giat,
          pagu: pagu,
          created_at: Time.now,
          updated_at: Time.now,
          kode_opd: @id_opd # warning hard coded
        }
      end
      ProgramKegiatan.upsert_all(data_subkegiatan, unique_by: :identifier_belanja)
    end

    def proses_data_musrenbang(response)
      data = Oj.load(response.body)
      data_musrenbang = data['data']
      musrenbangs = []
      data_musrenbang.each do |musren|
        id_unik = musren['id_usulan']
        id_kamus = musren['id_kamus']
        tahun = musren['tahun']
        alamat = musren['alamat_teks']
        uraian = musren['koefisien']
        usulan = musren['masalah']
        opd = musren['rev_unit'] # TODO: make column for this
        musrenbangs << { id_unik: id_unik, opd: opd,
                         id_kamus: id_kamus, tahun: tahun, alamat: alamat, usulan: usulan,
                         uraian: uraian, created_at: Time.now, updated_at: Time.now }
      end
      Musrenbang.upsert_all(musrenbangs, unique_by: :id_unik)
    end

    def proses_data_pokir(response)
      data = Oj.load(response.body)
      data_pokirs = data['data']
      pokirs = []
      data_pokirs.each do |pokir|
        id_unik = pokir['id_reses']
        id_kamus = pokir['id_kamus']
        tahun = pokir['tahun']
        alamat = pokir['alamat_teks']
        uraian = pokir['koefisien']
        usulan = pokir['masalah']
        opd = pokir['rev_unit']
        pokirs << { id_unik: id_unik, id_kamus: id_kamus, usulan: usulan,
                    tahun: tahun, alamat: alamat, uraian: uraian, opd: opd,
                    created_at: Time.now, updated_at: Time.now }
      end
      Pokpir.upsert_all(pokirs, unique_by: :id_unik)
    end

    def proses_data_kamus_usulan(response)
      data = Oj.load(response.body)
      data_kamus = data['data']
      kamus_usulans = []
      data_kamus.each do |kamus|
        id_kamus = kamus['id_kamus']
        id_unit = kamus['id_unit']
        id_program = kamus['id_program']
        bidang_urusan = kamus['bidang_urusan']
        usulan = kamus['giat_teks']
        kamus_usulans << { id_kamus: id_kamus, id_unit: id_unit, id_program: id_program,
                           bidang_urusan: bidang_urusan, usulan: usulan,
                           created_at: Time.now, updated_at: Time.now }
      end
      KamusUsulan.upsert_all(kamus_usulans, unique_by: :id_kamus)
    end

    # Basis sinkronisasi data subkegiatan
    def proses_data_subkegiatan_opd(response)
      data = Oj.load(response.body)
      data_detail = data['data']
      subkegiatans = data_detail.uniq { |el| el['id_sub_skpd'].to_s + '-' + el['id_sub_giat'].to_s }
      data_subkegiatan = []
      subkegiatans.each do |sub|
        identifier_belanja = sub['id_sub_skpd'].to_s + '-' + sub['id_sub_giat'].to_s
        tahun = sub['tahun']
        kode_skpd = sub["kode_skpd"]
        kode_sub_skpd = sub["kode_sub_skpd"]
        id_unit = sub['id_skpd']
        id_sub_unit = sub['id_sub_skpd']
        kode_urusan = sub['kode_urusan']
        nama_urusan = sub['nama_urusan']
        kode_bidang_urusan = sub['kode_bidang_urusan']
        nama_bidang_urusan = sub['nama_bidang_urusan']
        id_program_sipd = sub['id_program']
        kode_program = sub['kode_program']
        nama_program = sub['nama_program']
        id_giat = sub['id_giat']
        kode_giat = sub['kode_giat']
        nama_kegiatan = sub['nama_giat']
        # indikator_keg = sub['outcome_giat2'].first['indikator_keg']
        # target_keg = sub['outcome_giat2'].first['target_keg']
        # satuan_keg = sub['outcome_giat2'].first['satuan_keg']
        id_sub_giat = sub['id_sub_giat']
        kode_sub_giat = sub['kode_sub_giat']
        nama_sub_giat = sub['nama_sub_giat']
        indikator_sub = sub['indikator_sub']
        target_sub = sub['target_sub']
        satuan_sub = sub['satuan_sub']
        data_subkegiatan << {
          identifier_belanja: identifier_belanja,
          tahun: tahun,
          kode_skpd: kode_skpd,
          kode_sub_skpd: kode_sub_skpd,
          id_unit: id_unit,
          id_sub_unit: id_sub_unit,
          kode_urusan: kode_urusan,
          nama_urusan: nama_urusan,
          kode_bidang_urusan: kode_bidang_urusan,
          nama_bidang_urusan: nama_bidang_urusan,
          id_program_sipd: id_program_sipd,
          kode_program: kode_program,
          nama_program: nama_program,
          id_giat: id_giat,
          kode_giat: kode_giat,
          nama_kegiatan: nama_kegiatan,
          # indikator_kinerja: indikator_keg,
          # target: target_keg,
          # satuan: satuan_keg,
          id_sub_giat: id_sub_giat,
          kode_sub_giat: kode_sub_giat,
          nama_subkegiatan: nama_sub_giat,
          indikator_subkegiatan: indikator_sub,
          target_subkegiatan: target_sub,
          satuan_target_subkegiatan: satuan_sub,
          created_at: Time.now,
          updated_at: Time.now,
          kode_opd: @id_opd # warning hard coded
        }
      end
      ProgramKegiatan.upsert_all(data_subkegiatan, unique_by: :identifier_belanja)
    end
  end
end
