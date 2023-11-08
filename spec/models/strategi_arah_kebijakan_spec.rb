require 'rails_helper'

RSpec.describe StrategiArahKebijakan do

  def strategi_kebijakan(tahun, kode_opds)
    StrategiArahKebijakan.new(tahun: tahun, kode_opd: kode_opds)
  end

  let(:opd) { create(:opd,
                     kode_opd: '5.01.5.05.0.00.02.0000',
                     kode_unik_opd: '5.01.5.05.0.00.02.0000',
                     nama_opd: 'Badan Perencana') }

  let(:isu_strategis_opd) { create(:isu_strategis_opd,
                                   kode_opd: '5.01.5.05.0.00.02.0000',
                                   isu_strategis: 'Contoh Isu',
                                   kode: 'kode_a',
                                   tahun: '2023') }
  let(:urusan) { create(:master_urusan) }
  let(:bidang_urusan) { create(:master_bidang_urusan) }

  it 'should get opd by kode_unik_opd' do
    strategi = StrategiArahKebijakan.new(tahun: '2023', kode_opd: opd.kode_unik_opd)
    expect(strategi.opd).to eq opd
  end

  it 'should get isu_strategis_opd' do
    strategi = StrategiArahKebijakan.new(tahun: '2023', kode_opd: opd.kode_unik_opd)
    expect(strategi.isu_strategis_opds).to include isu_strategis_opd
  end

  it 'should get tujuan_opd' do
    strategi = StrategiArahKebijakan.new(tahun: '2023', kode_opd: opd.kode_unik_opd)

    tujuan_opd = TujuanOpd.create!(kode_unik_opd: opd.kode_unik_opd,
                                   id_tujuan: 'tujuan_a',
                                   tujuan: 'Contoh Tujuan',
                                   urusan_id: urusan.id,
                                   bidang_urusan_id: bidang_urusan.id)
    expect(strategi.tujuan_opds).to include tujuan_opd
  end

  it 'should get strategi_opd' do
    strategi = StrategiArahKebijakan.new(tahun: '2023', kode_opd: opd.kode_unik_opd)

    strategi_opd = StrategiPohon.create!(opd_id: opd.id,
                                         role: 'eselon_2',
                                         nip_asn: '123456',
                                         strategi: 'Contoh Strategi',
                                         tahun: '2023')
    expect(strategi.strategi_opds).to include strategi_opd
  end
end
