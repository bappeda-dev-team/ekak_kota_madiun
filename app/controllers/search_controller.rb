class SearchController < ApplicationController
  before_action :usulan_params

  def usulan_user
    @param = params[:q] || ''
    kode_sasaran = params[:kode]
    # searchable_user = if @usulan_type == 'Inovasi'
    #                     Search::AllUsulan.where(searchable_type: @usulan_type, tahun: @tahun, nip_asn: ['', @nip_asn])
    #                   else
    #                     Search::AllUsulan.where(searchable_type: @usulan_type, nip_asn: @nip_asn, tahun: @tahun)
    #                   end

    @results = if @usulan_type == 'Inovasi'
                 # search including kota (no nip_asn)
                 usulan_inovasi_search(kode_sasaran: kode_sasaran)
               elsif @usulan_type == 'Pokpir'
                 usulan_pokpir_search(kode_sasaran: kode_sasaran)
               else
                 # search only pribadi
                 Search::AllUsulan.where(searchable_type: @usulan_type, nip_asn: @nip_asn, tahun: @tahun)
                                  .where("sasaran_id is null and usulan ILIKE ?", "%#{@param}%")
                                  .order(searchable_id: :desc)
                                  .includes(:searchable)
                                  .collect(&:searchable)
               end
  end

  private

  def usulan_pokpir_search(kode_sasaran: '')
    @opd = Opd.unscoped.find_by(kode_unik_opd: @kode_opd)

    all_usulans = Search::AllUsulan.where(searchable_type: @usulan_type,
                                          tahun: @tahun)
                                   .where("usulan ILIKE ?", "%#{@param}%")
                                   .order(searchable_id: :desc)
                                   .includes(:searchable)
                                   .collect(&:searchable)

    # get usulan pokpir where
    # nip asn still blank
    # mean only one asn one rekin
    # can take this usulan
    # TODO: fix opd comparer, it's danger
    all_usulans.select do |pokpir|
      pokpir.from_kota_only && pokpir.opd_pokpir&.id == @opd.id
    end
  end

  def usulan_inovasi_search(kode_sasaran: '')
    @opd = Opd.unscoped.find_by(kode_unik_opd: @kode_opd)

    all_usulans = Search::AllUsulan.where(searchable_type: @usulan_type,
                                          tahun: @tahun)
                                   .where("usulan ILIKE ?", "%#{@param}%")
                                   .order(searchable_id: :desc)
                                   .includes(:searchable)
                                   .collect(&:searchable)

    @kode_opd = if @opd.setda?
                  @opd.all_kode_setda
                else
                  [@kode_opd]
                end
    usulan_kolabs = all_usulans.select do |inovasi|
      inovasi.from_kota_only && inovasi.get_kolaborator(@kode_opd)
    end

    if kode_sasaran.present?
      usulan_kolabs.reject do |inovasi|
        inovasi.all_usulans.any? do |us|
          us.sasaran_id == kode_sasaran.to_i
        end
      end
    else
      usulan_kolabs
    end
  end

  def usulan_params
    @tahun = cookies[:tahun] || Date.current.year.to_s
    @kode_opd = cookies[:opd]
    @tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @usulan_type = params[:usulan_type].capitalize || ''
    @nip_asn = params[:nip_asn]
  end
end
