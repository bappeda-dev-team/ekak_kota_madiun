class SearchController < ApplicationController
  def usulan_user
    tahun = cookies[:tahun] || Date.current.year.to_s
    tahun_bener = tahun.match(/murni|perubahan/) ? tahun[/[^_]\d*/, 0] : tahun
    param = params[:q] || ''
    usulan_type = params[:usulan_type]
    nip_asn = params[:nip_asn]
    @results = Search::AllUsulan
               .where("sasaran_id is null and usulan ILIKE ?", "%#{param}%")
               .where(searchable_type: usulan_type.capitalize, nip_asn: nip_asn, tahun: tahun)
               .order(searchable_id: :desc)
               .includes(:searchable)
               .collect(&:searchable)
  end
end
