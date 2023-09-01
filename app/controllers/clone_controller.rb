class CloneController < ApplicationController
  def show
    pohon = Pohon.find params[:id]
    tahun = cookies[:tahun]
    render partial: 'clone/form_clone', locals: { pohon: pohon, tahun_asal: tahun }, layout: false
  end

  def pohon_tematik
    tahun_asal = params[:tahun_asal]
    tahun_anggaran = KelompokAnggaran.find(params[:tahun_tujuan]).kode_kelompok
    @tahun = tahun_anggaran.match(/murni/) ? tahun_anggaran[/[^_]\d*/, 0] : tahun_anggaran

    pohon = Pohon.find(params[:id])

    ket = "clone_dari_#{tahun_asal}"

    # child_level1 = Pohon.where(pohon_ref_id: pohon.id)
    # child_level2 = Pohon.where(pohon_ref_id: child_level1.map(&:id))
    # child_level3 = Pohon.where(pohon_ref_id: child_level2.map(&:id))
    # child_level4 = Pohon.where(pohon_ref_id: child_level3.map(&:id))
    # child_level5 = Pohon.where(pohon_ref_id: child_level4.map(&:id))
    # child_level6 = Pohon.where(pohon_ref_id: child_level5.map(&:id))

    operation = PohonCloner.call(pohon, traits: :pohon_tematik,
                                        tahun: @tahun, pohon_ref_id: '', keterangan: ket)
    operation.to_record
    operation.persist!
    clone_pohon = operation.to_record
    # clone_pohon_id = clone_pohon.id

    # clone_level1 = []
    # child_level1.each do |lvl1|
    #   op = PohonCloner.call(lvl1, traits: :pohon_tematik,
    #                               tahun: @tahun, pohon_ref_id: clone_pohon_id, keterangan: ket)
    #   op.to_record
    #   op.persist!
    #   clone = op.to_record
    #   clone_level1.append(clone.id)
    # end

    # return if clone_level1.empty?

    # clone_level2 = []
    # child_level2.each do |lvl2|
    #   binding.pry
    #   clone_level1.select { |lv| lv == lvl2.id }.each do |lvl1|
    #     op = PohonCloner.call(lvl2, traits: :pohon_tematik,
    #                                 tahun: @tahun, pohon_ref_id: lvl1, keterangan: ket)
    #     op.to_record
    #     op.persist!
    #     clone = op.to_record
    #     clone_level2.append(clone.id)
    #   end
    # end

    # return if clone_level2.empty?

    # clone_level3 = []
    # child_level3.each do |lvl3|
    #   clone_level2.select { |lv| lv == lvl3.id }.each do |lvl2|
    #     op = PohonCloner.call(lvl3, traits: :pohon_tematik,
    #                                 tahun: @tahun, pohon_ref_id: lvl2, keterangan: ket)
    #     op.to_record
    #     op.persist!
    #     clone = op.to_record
    #     clone_level3.append(clone.id)
    #   end
    # end

    # return if clone_level3.empty?

    # clone_level4 = []
    # child_level4.each do |lvl4|
    #   clone_level3.select { |lv| lv == lvl4.id }.each do |lvl3|
    #     op = PohonCloner.call(lvl4, traits: :pohon_tematik,
    #                                 tahun: @tahun, pohon_ref_id: lvl3, keterangan: ket)
    #     op.to_record
    #     op.persist!
    #     clone = op.to_record
    #     clone_level4.append(clone.id)
    #   end
    # end

    # return if clone_level4.empty?

    # clone_level5 = []
    # child_level5.each do |lvl5|
    #   clone_level4.select { |lv| lv == lvl5.id }.each do |lvl4|
    #     op = PohonCloner.call(lvl5, traits: :pohon_tematik,
    #                                 tahun: @tahun, pohon_ref_id: lvl4, keterangan: ket)
    #     op.to_record
    #     op.persist!
    #     clone = op.to_record
    #     clone_level5.append(clone.id)
    #   end
    # end

    # return if clone_level5.empty?

    # child_level6.each do |lvl6|
    #   clone_level5.select { |lv| lv == lvl6.id }.each do |lvl5|
    #     op = PohonCloner.call(lvl6, traits: :pohon_tematik,
    #                                 tahun: @tahun, pohon_ref_id: lvl5)
    #     op.to_record
    #     op.persist!
    #   end
    # end
  end
end
