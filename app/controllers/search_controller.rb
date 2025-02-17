class SearchController < ApplicationController
  before_action :usulan_params

  def usulan_user
    param = params[:q] || ''
    usulan_search = if @usulan_type == 'inovasi'
                      "usulan ILIKE ?"
                    else
                      "sasaran_id is null and usulan ILIKE ?"
                    end
    searchable_user = if @usulan_type == 'inovasi'
                        where(searchable_type: @usulan_type, tahun: @tahun)
                      else
                        where(searchable_type: @usulan_type, nip_asn: @nip_asn, tahun: @tahun)
                      end
    @results = Search::AllUsulan
               .where(usulan_search, "%#{param}%")
               .searchable_user
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
