# frozen_string_literal: true

class Pohon::BodyComponent < ViewComponent::Base
  def initialize(item:)
    @item = item
  end

  def jenis_item
    prefix = case @item.role
             when 'pohon_kota'
               'Tematik Kota'
             when 'sub_pohon_kota'
               'Sub-Tematik Kota'
             when 'sub_sub_pohon_kota'
               'Sub Sub-Tematik Kota'
             when 'strategi_pohon_kota'
               'Strategic'
             else
               @item.role.chomp("_pohon_kota")
             end
    prefix.titleize
  end

  def nama_item
    @item.pohonable_type.downcase.include?('tematik') ? @item.pohonable.tema : @item.pohonable.to_s
  end

  def sumber_item
    @item.instance_of?(Pohon) ? @item.pohonable : @item
  end

  def have_sumber_item?
    sumber_item.present?
  end

  def have_perangkat_daerah?
    @item.pohonable_type == 'Strategi' || @item.pohonable_type == 'StrategiPohon'
  end

  def hide_detail?
    have_perangkat_daerah? ? 'detail d-none' : ''
  end

  def perangkat_daerah_item
    @item.pohonable.opd.to_s
  end

  def keterangan
    jenis_tematiks = %w[Tematik SubTematik SubSubTematik]

    if @item.pohonable_type.in? jenis_tematiks
      @item.pohonable.keterangan
    else
      @item.keterangan
    end
  end
end
