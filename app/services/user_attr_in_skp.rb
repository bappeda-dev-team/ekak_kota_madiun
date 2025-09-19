class UserAttrInSkp
  include ActionView::Helpers::DateHelper

  def initialize(user: nil, tahun: '')
    @user = user
    @tahun = tahun
  end

  def cari_perubahan
    { nip: @user.nik,
      nama: @user.nama,
      opd: @user.opd.to_s,
      kode_opd: @user.opd.kode_unik_opd,
      tahun: @tahun,
      jumlah_sasaran: perubahan_sasaran.size,
      perubahans: perubahan_sasaran }
  end

  def perubahan_sasaran
    @user.sasaran_asn_sync_skp(tahun: @tahun)
         .flat_map do |ss|
      { id_sasaran: ss.id_rencana,
        tahun_sasaran: ss.tahun,
        sasaran_kinerja: ss.sasaran_kinerja,
        ada_perubahan: update_dibulan_ini?(ss.updated_at),
        dibuat: format_tanggal(ss.created_at),
        update_terakhir: format_tanggal(ss.updated_at),
        terakhir_diubah: terakhir_update(ss.updated_at),
        indikator_sasaran: perubahan_indikator(ss) }
    end
  end

  def perubahan_indikator(sasaran)
    sasaran.indikator_sasarans.flat_map do |ind|
      { id_indikator: ind.id,
        id_sasaran: ind.sasaran_id,
        indikator: ind.indikator_kinerja,
        ada_perubahan: banyak_update?(ind.updated_at, ind&.manual_ik&.updated_at),
        sumber_data: ind.sumber_data,
        rumus_perhitungan: ind.rumus_perhitungan,
        target: ind.target,
        satuan: ind.satuan,
        dibuat: format_tanggal(ind.created_at),
        update_terakhir: format_tanggal(ind.updated_at),
        terakhir_diubah: terakhir_update(ind.updated_at) }
    end
  end

  private

  # cek jika ada perubahan dalam bulan ini
  def update_dibulan_ini?(tanggal)
    tanggal >= 1.month.ago
  end

  def banyak_update?(*tanggals)
    tanggals.any? { |tt| update_dibulan_ini?(tt) }
  end

  def format_tanggal(tanggal)
    tanggal.strftime("%Y-%m-%d %H:%M:%S")
  end

  def terakhir_update(waktu_dibuat)
    "#{time_ago_in_words(waktu_dibuat, locale: :id)} yang lalu"
  end
end
