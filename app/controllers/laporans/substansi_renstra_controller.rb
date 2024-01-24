class Laporans::SubstansiRenstraController < ApplicationController
  def dasar_hukum
    @kode_opd = cookies[:opd]
    @tahun = cookies[:tahun]
    @opd = Opd.find_by(kode_unik_opd: @kode_opd)

    @dasar_hukums = @opd.sasarans
                        .includes(%i[strategi
                                     user
                                     usulans
                                     mandatoris
                                     program_kegiatan
                                     indikator_sasarans])
                        .order(nip_asn: :asc)
                        .dengan_strategi
                        .flat_map(&:mandatoris)
                        .select { |mandatori| mandatori.tahun == @tahun }
  end
end
