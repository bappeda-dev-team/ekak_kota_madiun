class SearchController < ApplicationController
  before_action :usulan_params

  def usulan_user
    param = params[:q] || ''
    usulan_search = if @usulan_type == 'Inovasi'
                      "usulan ILIKE ?"
                    else
                      "sasaran_id is null and usulan ILIKE ?"
                    end
    searchable_user = if @usulan_type == 'Inovasi'
                        Search::AllUsulan.where(searchable_type: @usulan_type, tahun: @tahun)
                      else
                        Search::AllUsulan.where(searchable_type: @usulan_type, nip_asn: @nip_asn, tahun: @tahun)
                      end

    @results = searchable_user
               .where(usulan_search, "%#{param}%")
               .order(searchable_id: :desc)
               .includes(:searchable)
               .collect(&:searchable)
  end

  private

  def usulan_params
    @tahun = cookies[:tahun] || Date.current.year.to_s
    @tahun_bener = @tahun.match(/murni|perubahan/) ? @tahun[/[^_]\d*/, 0] : @tahun
    @usulan_type = params[:usulan_type].capitalize || ''
    @nip_asn = params[:nip_asn]
  end
end
