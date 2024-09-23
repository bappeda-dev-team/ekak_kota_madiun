class RadKota
  def initialize(tahun: '', parent_id: '')
    @parent_id = parent_id
    @tahun = tahun
  end

  def pohon_sub
    Pohon.find_by(id: @parent_id, tahun: @tahun)
  end

  def sub_sasaran_kota
    Pohon.where(pohon_ref_id: @parent_id,
                tahun: @tahun,
                role: 'sub_sub_pohon_kota')
         .select(&:pohonable)
  end

  def rad_sasaran_kota
    Pohon.includes(:sub_pohons)
         .where(pohon_ref_id: @parent_id,
                tahun: @tahun,
                role: 'strategi_pohon_kota')
         .select(&:pohonable)
  end
end
