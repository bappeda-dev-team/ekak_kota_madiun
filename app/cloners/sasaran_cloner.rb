class SasaranCloner < Clowne::Cloner
  adapter :active_record

  trait :with_indikators do
    include_association :indikator_sasarans, params: proc { |params, sasaran|
      {
        id_indikator: params[:tahun],
        sasaran_id: sasaran.id_rencana,
        tahun: params[:tahun]
      }
    }
    include_association :dasar_hukums, params: proc { |params, sasaran|
      {
        sasaran_id: sasaran.id_rencana,
        tahun: params[:tahun]
      }
    }
    include_association :rincian
    include_association :permasalahans
    include_association :latar_belakangs
    nullify :id_rencana
    nullify :strategi_id

    after_clone do |origin, cloned, tahun:, **|
      cloned.id_rencana = "clone_#{origin.id_rencana}_#{tahun}"
    end

    after_persist do |origin, cloned, **|
      cloned.indikator_sasarans.each do |indikator|
        indikator.update(sasaran_id: origin.id_rencana) if indikator.keterangan == cloned.id_rencana
      end
      cloned.dasar_hukums.each do |dashu|
        dashu.update(sasaran_id: origin.id_rencana) if dashu.keterangan == cloned.id_rencana
      end
    end
  end

  trait :pokin do
    include_association :indikator_sasarans, params: proc { |params, sasaran|
      {
        id_indikator: params[:tahun],
        sasaran_id: sasaran.id_rencana,
        tahun: params[:tahun]
      }
    }
    nullify :id_rencana
    nullify :nip_asn

    finalize do |_source, record, tahun:, **|
      record.tahun = "#{tahun}_pokin"
      record.keterangan = "#{tahun}_pokin"
      record.created_at = Time.current
      record.updated_at = Time.current
    end
  end

  finalize do |_source, record, tahun:, clone_tahun_asal:, clone_oleh:, clone_asli:, **|
    record.tahun = tahun
    record.created_at = Time.current
    record.updated_at = Time.current
    record.clone_tahun_asal = clone_tahun_asal
    record.clone_oleh = clone_oleh
    record.clone_asli = clone_asli
  end
end
