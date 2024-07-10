module PohonKinerjaOpdsHelper
  def child_strategi(parent, childs)
    childs.select { |str| str.pohon_ref_id.to_i == parent.id }
  rescue NoMethodError
    []
  end

  def childs(pohon_kinerja_opd)
    case pohon_kinerja_opd.role
    when 'eselon_2'
      child_strategi(pohon_kinerja_opd, @tactical_opd)
    when 'strategi_pohon_kota'
      child_strategi(pohon_kinerja_opd, @tactical_kota)
    when 'eselon_3'
      child_strategi(pohon_kinerja_opd, @operational_opd)
    when 'tactical_pohon_kota'
      child_strategi(pohon_kinerja_opd, @operational_kota)
    else
      child_strategi(pohon_kinerja_opd, @staff_opd)
    end
  end

  def anggaran_pohon(sasaran, role)
    strategi = case role
               when 'pohon_kota'
                 AnggaranPohon::Tematik.new(sasaran, @tahun)
               when 'sub_pohon_kota'
                 AnggaranPohon::SubTematik.new(sasaran, @tahun)
               when 'sub_sub_pohon_kota'
                 AnggaranPohon::SubSubTematik.new(sasaran, @tahun)
               when 'eselon_2'
                 AnggaranPohon::Strategic.new(sasaran)
               when 'eselon_3'
                 AnggaranPohon::Tactical.new(sasaran)
               else
                 AnggaranPohon::Operational.new(sasaran)
               end
    anggaran = AnggaranSasaran.new(strategi)
    anggaran.anggaran
  end

  def pagu_pohon(sasaran, role)
    strategi = case role
               when 'pohon_kota'
                 AnggaranPohon::Tematik.new(sasaran, @tahun)
               when 'sub_pohon_kota'
                 AnggaranPohon::SubTematik.new(sasaran, @tahun)
               when 'sub_sub_pohon_kota'
                 AnggaranPohon::SubSubTematik.new(sasaran, @tahun)
               when 'eselon_2'
                 AnggaranPohon::Strategic.new(sasaran)
               when 'eselon_3'
                 AnggaranPohon::Tactical.new(sasaran)
               else
                 AnggaranPohon::Operational.new(sasaran)
               end
    anggaran = AnggaranSasaran.new(strategi)
    number_with_delimiter(anggaran.anggaran)
  end

  def program_pohon(sasaran, role)
    strategi = case role
               when 'pohon_kota'
                 AnggaranPohon::Tematik.new(sasaran, @tahun)
               when 'sub_pohon_kota'
                 AnggaranPohon::SubTematik.new(sasaran, @tahun)
               when 'sub_sub_pohon_kota'
                 AnggaranPohon::SubSubTematik.new(sasaran, @tahun)
               when 'eselon_2'
                 AnggaranPohon::Strategic.new(sasaran)
               when 'eselon_3'
                 AnggaranPohon::Tactical.new(sasaran)
               when 'eselon_4'
                 AnggaranPohon::Operational.new(sasaran)
               end
    context = AnggaranSasaran.new(strategi)
    context.programs.reject { |prg| prg.nama_program =~ /PROGRAM PENUNJANG/ }
  end
end
