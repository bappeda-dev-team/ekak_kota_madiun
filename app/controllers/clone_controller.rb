class CloneController < ApplicationController
  def show
    pohon = Pohon.find params[:id]
    tahun = cookies[:tahun]
    url = pohon_tematik_clone_path(pohon)
    render partial: 'clone/form_clone', locals: { pohon: pohon, tahun_asal: tahun, url: url }, layout: false
  end

  def opd
    @opd = Opd.find params[:id]
    @tahun = cookies[:tahun]
    queries = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: @opd.kode_unik_opd)
    @strategi_opds = {
      strategi_opd: queries.strategi_opd.size,
      tactical_opd: queries.tactical_opd.size,
      operational_opd: queries.operational_opd.size,
      staff_opd: queries.staff_opd.size
    }
    @url = pohon_opd_clone_path(params[:id])
    render layout: false
  end

  def pohon_opd
    tahun_asal = params[:tahun_asal]
    tahun_anggaran = KelompokAnggaran.find(params[:tahun_tujuan]).kode_kelompok
    @tahun = tahun_anggaran.match(/murni/) ? tahun_anggaran[/[^_]\d*/, 0] : tahun_anggaran

    queries = PohonKinerjaOpdQueries.new(tahun: tahun_asal, kode_opd: params[:kode_opd])

    strategi_opds = queries.strategi_opd
    tactical_opd = queries.tactical_opd
    operational_opd = queries.operational_opd
    staff_opd = queries.staff_opd

    ket = "clone_dari_#{tahun_asal}"

    clone_strategi = strategi_opds.map do |strategi|
      operation = StrategiCloner.call(strategi, traits: :strategi_pohon,
                                                tahun: @tahun, keterangan: ket, parent_id: nil)
      operation.to_record
      operation.persist
      clone = operation.to_record
      parent_id = clone.id

      tactical_opd.select { |str| str.strategi_ref_id.to_i == strategi.id }.each do |tactical|
        operation_tac = StrategiCloner.call(tactical, traits: :strategi_pohon,
                                                      tahun: @tahun, parent_id: parent_id,
                                                      keterangan: ket)
        operation_tac.to_record
        operation_tac.persist
        clone_tac = operation_tac.to_record
        parent_tac = clone_tac.id

        operational_opd.select { |str| str.strategi_ref_id.to_i == tactical.id }.each do |operational|
          operation_op = StrategiCloner.call(operational, traits: :strategi_pohon,
                                                          tahun: @tahun, parent_id: parent_tac,
                                                          keterangan: ket)
          operation_op.to_record
          operation_op.persist
          clone_op = operation_op.to_record
          parent_op = clone_op.id

          staff_opd.select { |str| str.strategi_ref_id.to_i == operational.id }.each do |staff|
            operation_st = StrategiCloner.call(staff, traits: :strategi_pohon,
                                                      tahun: @tahun, parent_id: parent_op,
                                                      keterangan: ket)
            operation_st.to_record
            operation_st.persist
          end
        end
      end
    end

    queries_baru = PohonKinerjaOpdQueries.new(tahun: @tahun, kode_opd: params[:kode_opd])
    @strategi_opds = {
      strategi_opd: queries_baru.strategi_opd.size,
      tactical_opd: queries_baru.tactical_opd.size,
      operational_opd: queries_baru.operational_opd.size,
      staff_opd: queries_baru.staff_opd.size
    }

    if clone_strategi.any?
      render json: { resText: "Clone berhasil", html_content: html_content(@strategi_opds) }, status: :created
    else
      render json: { resText: "Terjadi kesalahan" }.to_json,
             status: :unprocessable_entity
    end
  end

  def pohon_tematik
    tahun_asal = params[:tahun_asal]
    tahun_anggaran = KelompokAnggaran.find(params[:tahun_tujuan]).kode_kelompok
    @tahun = tahun_anggaran.match(/murni/) ? tahun_anggaran[/[^_]\d*/, 0] : tahun_anggaran

    ket = "clone_dari_#{tahun_asal}"
    pohon = Pohon.find(params[:id])

    @pohon = PohonTematikQueries.new(tahun: tahun_asal)

    tema = pohon.pohonable
    tema_operation = TematikCloner.call(tema, tahun: @tahun, keterangan: ket)
    tema_operation.to_record
    tema_operation.persist
    tema_clone = tema_operation.to_record
    tema_clone_id = tema_clone.id

    pohon_tema_operation = PohonCloner.call(pohon, traits: :pohon_no_sub,
                                                   tahun: @tahun,
                                                   pohonable_id: tema_clone_id,
                                                   pohon_ref_id: nil)
    pohon_tema_operation.to_record
    pohon_tema_operation.persist
    pohon_tema_clone = pohon_tema_operation.to_record
    pohon_tema_id = pohon_tema_clone.id

    clone_sub_pohons = @pohon.sub_tematiks.select { |ph| ph.pohon_ref_id == pohon.id }.map do |sub_ph|
      sub_tema = sub_ph.pohonable
      sub_tema_operation = SubTematikCloner.call(sub_tema, tahun: @tahun,
                                                           tematik_ref_id: tema_clone_id,
                                                           keterangan: ket)
      sub_tema_operation.to_record
      sub_tema_operation.persist
      sub_tema_clone = sub_tema_operation.to_record
      sub_tema_clone_id = sub_tema_clone.id

      pohon_sub_tema_operation = PohonCloner.call(sub_ph, traits: :pohon_no_sub,
                                                          tahun: @tahun,
                                                          pohon_ref_id: pohon_tema_id,
                                                          pohonable_id: sub_tema_clone_id)
      pohon_sub_tema_operation.to_record
      pohon_sub_tema_operation.persist
      pohon_sub_tema_clone = pohon_sub_tema_operation.to_record
      pohon_sub_tema_id = pohon_sub_tema_clone.id

      clone_strategi_tematik(pohon: @pohon, tahun: @tahun, parent_id: sub_ph.id,
                             new_parent_id: pohon_sub_tema_id, ket: ket)

      @pohon.sub_sub_tematiks.select { |sb| sb.pohon_ref_id == sub_ph.id }.each do |sub_sub_ph|
        sub_sub_tema = sub_sub_ph.pohonable
        sub_sub_tema_operation = SubSubTematikCloner.call(sub_sub_tema, tahun: @tahun,
                                                                        tematik_ref_id: sub_tema_clone_id,
                                                                        keterangan: ket)
        sub_sub_tema_operation.to_record
        sub_sub_tema_operation.persist
        sub_sub_tema_clone = sub_sub_tema_operation.to_record
        sub_sub_tema_clone_id = sub_sub_tema_clone.id

        pohon_sub_sub_tema_operation = PohonCloner.call(sub_sub_ph, traits: :pohon_no_sub,
                                                                    tahun: @tahun,
                                                                    pohon_ref_id: pohon_sub_tema_id,
                                                                    pohonable_id: sub_sub_tema_clone_id)
        pohon_sub_sub_tema_operation.to_record
        pohon_sub_sub_tema_operation.persist
        pohon_sub_sub_tema_clone = pohon_sub_sub_tema_operation.to_record
        pohon_sub_sub_tema_id = pohon_sub_sub_tema_clone.id

        clone_strategi_tematik(pohon: @pohon, tahun: @tahun, parent_id: sub_sub_ph.id,
                               new_parent_id: pohon_sub_sub_tema_id, ket: ket)
      end
    end

    if clone_sub_pohons.any?
      render json: { resText: "Pohon di clone ke #{@tahun}" }, status: :created
    else
      render json: { resText: 'Gagal, terdapat kesalahan di server' }, status: :unprocessable_entity
    end
  end

  def clone_sasaran
    sasaran = Sasaran.find params[:id]
    tahun = cookies[:tahun]
    url = rencana_kinerja_clone_path(sasaran)
    render partial: 'clone/form_clone_sasaran', locals: { sasaran: sasaran, tahun_asal: tahun, url: url }, layout: false
  end

  def rencana_kinerja
    tahun_asal = params[:tahun_asal]
    tahun_anggaran = KelompokAnggaran.find(params[:tahun_tujuan]).kode_kelompok
    @tahun = tahun_anggaran.match(/murni/) ? tahun_anggaran[/[^_]\d*/, 0] : tahun_anggaran
    sasaran = Sasaran.find(params[:id])

    operation = SasaranCloner.call(sasaran,
                                   traits: :with_indikators,
                                   tahun: @tahun,
                                   clone_tahun_asal: tahun_asal,
                                   clone_oleh: current_user.id,
                                   clone_asli: sasaran.id)
    begin
      operation.to_record
      operation.persist!
      render json: { resText: "Berhasil di clone ke #{@tahun}" },
             status: :created
    rescue ActiveRecord::RecordNotUnique
      render json: { resText: "Rencana kinerja sudah dikloning di-tahun #{@tahun}",
                     html_content: "<p class='alert alert-danger'>Rencana kinerja sudah dikloning di-tahun #{@tahun}</p>" },
             status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid
      render json: { resText: "terdapat kekurangan isian",
                     html_content: "<p class='alert alert-danger'>terdapat kekurangan isian rencana kinerja</p>" },
             status: :unprocessable_entity
    rescue StandardError
      render json: { resText: "Terjadi kesalahan",
                     html_content: "<p class='alert alert-danger'>Terjadi kesalahan</p>" },
             status: :unprocessable_entity
    end
  end

  def tahun_clone
    tahun_asal = cookies[:tahun]
    url = params[:url]
    render partial: 'clone/form_tahun_clone', locals: { judul: params[:judul], tahun_asal: tahun_asal, url: url },
           layout: false
  end

  def transfer_ke_pohon_kinerja
    strategis = Strategi.where(tahun: params[:tahun], role: params[:role], opd_id: params[:opd])
    tahun_tujuan = params[:tahun_tujuan]
    return unless strategis.any?

    results = strategis.map do |strategi|
      operation = StrategiCloner.call(strategi, tahun: tahun_tujuan,
                                                opd_id: params[:opd],
                                                strategi_cascade_link: strategi.id,
                                                traits: [:no_bawahan])
      operation.to_record
      operation.persist!
    end
    if results.any?
      render json: { resText: "Berhasil clone ke #{tahun_tujuan}" }, status: :created
    else
      render json: { resText: 'Gagal, terdapat kesalahan di server' }, status: :unprocessable_entity
    end
  end

  def clone_mandatori
    mandatori = Mandatori.find params[:id]
    tahun = cookies[:tahun]
    url = mandatori_cloner_clone_path(mandatori)
    render partial: 'clone/form_clone_mandatori', locals: { mandatori: mandatori,
                                                            tahun_asal: tahun,
                                                            url: url },
           layout: false
  end

  def mandatori_cloner
    tahun_anggaran = KelompokAnggaran.find(params[:tahun_tujuan]).kode_kelompok
    @tahun = tahun_anggaran.match(/murni/) ? tahun_anggaran[/[^_]\d*/, 0] : tahun_anggaran
    mandatori = Mandatori.find(params[:id])

    operation = MandatoriCloner.call(mandatori, tahun: @tahun)

    begin
      operation.to_record
      operation.persist!
      render json: { resText: "Berhasil di clone ke #{@tahun}" },
             status: :created
    rescue ActiveRecord::RecordNotUnique
      render json: { resText: "Mandatori sudah dikloning di-tahun #{@tahun}",
                     html_content: "<p class='alert alert-danger'>Mandatori kinerja sudah dikloning di-tahun #{@tahun}</p>" },
             status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid
      render json: { resText: "terdapat kekurangan isian",
                     html_content: "<p class='alert alert-danger'>terdapat kekurangan isian</p>" },
             status: :unprocessable_entity
    rescue StandardError
      render json: { resText: "Terjadi kesalahan",
                     html_content: "<p class='alert alert-danger'>Terjadi kesalahan</p>" },
             status: :unprocessable_entity
    end
  end

  def isu_strategis_opd
    isu_strategis_opd = IsuStrategisOpd.find(params[:id])
    tahun_asal = params[:tahun_asal]
    tahun_anggaran = KelompokAnggaran.find(params[:tahun_tujuan]).kode_kelompok
    @tahun = tahun_anggaran.match(/murni/) ? tahun_anggaran[/[^_]\d*/, 0] : tahun_anggaran

    operation = IsuStrategisOpdCloner.call(isu_strategis_opd,
                                           traits: :with_permasalahan,
                                           tahun: @tahun, tahun_asal: tahun_asal)

    begin
      operation.to_record
      operation.persist!
      render json: { resText: "Berhasil clone ke tahun #{@tahun}" },
             status: :created
    rescue ActiveRecord::RecordNotUnique
      render json: { resText: "Isu Strategis OPD sudah dikloning di-tahun #{@tahun}",
                     html_content: "<p class='alert alert-danger'>Mandatori kinerja sudah dikloning di-tahun #{@tahun}</p>" },
             status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid
      render json: { resText: "terdapat kekurangan isian",
                     html_content: "<p class='alert alert-danger'>terdapat kekurangan isian</p>" },
             status: :unprocessable_entity
    rescue StandardError
      render json: { resText: "Terjadi kesalahan",
                     html_content: "<p class='alert alert-danger'>Terjadi kesalahan</p>" },
             status: :unprocessable_entity
    end
  end

  private

  def set_tahun_clone
    tahun_asal = params[:tahun_asal]
    tahun_anggaran = KelompokAnggaran.find(params[:tahun_tujuan]).kode_kelompok
    @tahun = tahun_anggaran.match(/murni/) ? tahun_anggaran[/[^_]\d*/, 0] : tahun_anggaran
  end

  def html_content(_strategi_opds)
    render_to_string(partial: 'clone/jumlah_strategi',
                     formats: 'html',
                     layout: false,
                     locals: { tahun: @tahun, hasil_clone: true })
  end

  def clone_strategi_tematik(pohon:, parent_id:, new_parent_id:, ket:, tahun:)
    pohon.strategi_tematiks.select { |str| str.pohon_ref_id == parent_id }.each do |phh_str|
      ph_str = phh_str.pohonable
      ph_str_operation = StrategiCloner.call(ph_str, traits: :strategi_pohon,
                                                     tahun: tahun,
                                                     parent_id: nil,
                                                     keterangan: ket)
      ph_str_operation.to_record
      ph_str_operation.persist
      ph_str_clone = ph_str_operation.to_record
      ph_str_clone_id = ph_str_clone.id

      pohon_str_operation = PohonCloner.call(phh_str, traits: :pohon_no_sub,
                                                      tahun: tahun,
                                                      pohon_ref_id: new_parent_id,
                                                      pohonable_id: ph_str_clone_id)
      pohon_str_operation.to_record
      pohon_str_operation.persist
      pohon_str_clone = pohon_str_operation.to_record
      pohon_str_id = pohon_str_clone.id

      pohon.tactical_tematiks.select { |tac| tac.pohon_ref_id == phh_str.id }.each do |phh_tac|
        ph_tac = phh_tac.pohonable
        ph_tac_operation = StrategiCloner.call(ph_tac, traits: :strategi_pohon,
                                                       tahun: tahun,
                                                       parent_id: ph_str_clone_id,
                                                       keterangan: ket)
        ph_tac_operation.to_record
        ph_tac_operation.persist
        ph_tac_clone = ph_tac_operation.to_record
        ph_tac_clone_id = ph_tac_clone.id

        pohon_tac_operation = PohonCloner.call(phh_tac, traits: :pohon_no_sub,
                                                        tahun: tahun,
                                                        pohon_ref_id: pohon_str_id,
                                                        pohonable_id: ph_tac_clone_id)
        pohon_tac_operation.to_record
        pohon_tac_operation.persist
        pohon_tac_operation.to_record
      end
    end
  end
end
