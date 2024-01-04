require 'rails_helper'

RSpec.describe "Clones", type: :request do
  let(:user) { create(:user) }
  let(:tematik) do
    create :tematik,
           tema: 'contoh tema a',
           keterangan: 'contoh keterangan'
  end
  let(:sub_tematik) do
    create :tematik,
           tema: 'contoh subtema a',
           type: 'SubTematik',
           tematik_ref_id: tematik.id,
           keterangan: 'contoh sub keterangan'
  end
  let(:sub_sub_tematik) do
    create :tematik,
           tema: 'contoh subsubtema a',
           type: 'SubSubTematik',
           tematik_ref_id: tematik.id,
           keterangan: 'contoh sub keterangan'
  end
  let(:strategic) do
    create :strategi,
           strategi: 'strategic 1',
           type: 'StrategiPohon',
           tahun: '2023'
  end
  let(:tactical) do
    create :strategi,
           strategi: 'tactical 1',
           type: 'StrategiPohon',
           tahun: '2023'
  end
  let(:tactical2) do
    create :strategi,
           strategi: 'tactical 2',
           type: 'StrategiPohon',
           tahun: '2023'
  end
  let(:operational) do
    create :strategi,
           strategi: 'operational 1',
           type: 'StrategiPohon',
           tahun: '2023'
  end

  let(:pohon) do
    create :pohon,
           pohonable_type: 'Tematik',
           pohonable_id: tematik.id,
           keterangan: 'pohon test',
           pohon_ref_id: '',
           role: 'pohon_kota',
           tahun: '2023'
  end
  let(:pohon_child1) do
    create :pohon,
           pohonable_type: 'SubTematik',
           pohonable_id: sub_tematik.id,
           keterangan: 'pohon test 1',
           pohon_ref_id: pohon.id,
           role: 'sub_pohon_kota',
           tahun: '2023'
  end
  let(:pohon_child12) do
    create :pohon,
           pohonable_type: 'SubSubTematik',
           pohonable_id: sub_sub_tematik.id,
           keterangan: 'pohon test 12',
           pohon_ref_id: pohon_child1.id,
           role: 'sub_sub_pohon_kota',
           tahun: '2023'
  end
  let(:pohon_child2) do
    create :pohon,
           pohonable_type: 'Strategi',
           pohonable_id: strategic.id,
           keterangan: 'pohon test 2',
           pohon_ref_id: pohon_child1.id,
           role: 'strategi_pohon_kota',
           tahun: '2023'
  end
  let(:pohon_child22) do
    create :pohon,
           pohonable_type: 'Strategi',
           pohonable_id: strategic.id,
           keterangan: 'pohon test 2',
           pohon_ref_id: pohon_child12.id,
           role: 'strategi_pohon_kota',
           tahun: '2023'
  end
  let(:pohon_child23) do
    create :pohon,
           pohonable_type: 'Strategi',
           pohonable_id: strategic.id,
           keterangan: 'pohon test 2',
           pohon_ref_id: pohon_child12.id,
           role: 'strategi_pohon_kota',
           tahun: '2023'
  end
  let(:pohon_child3) do
    create :pohon,
           pohonable_type: 'Strategi',
           pohonable_id: tactical.id,
           keterangan: 'pohon test 3',
           pohon_ref_id: pohon_child2.id,
           role: 'tactical_pohon_kota',
           tahun: '2023'
  end
  let(:pohon_child31) do
    create :pohon,
           pohonable_type: 'Strategi',
           pohonable_id: tactical2.id,
           keterangan: 'pohon test 3.1',
           pohon_ref_id: pohon_child2.id,
           role: 'tactical_pohon_kota',
           tahun: '2023'
  end
  let(:pohon_child4) do
    create :pohon,
           pohonable_type: 'Strategi',
           pohonable_id: operational.id,
           keterangan: 'pohon test 4',
           pohon_ref_id: pohon_child3.id,
           role: 'operational_pohon_kota',
           tahun: '2023'
  end
  let(:kelompok_anggaran) do
    create :kelompok_anggaran,
           tahun: '2023',
           kelompok: 'Perubahan'
  end

  describe "pohon_tematik" do
    before(:each) do
      sign_in user
    end
    it 'should duplicate pohon count' do
      tahun_asal = '2024'
      tahun_tujuan = kelompok_anggaran.id
      pohon_asli = pohon
      pohon_child1
      pohon_child2
      pohon_child3
      pohon_child31
      pohon_child4

      jumlah_awal = Pohon.count

      post "/clone/#{pohon_asli.id}/pohon_tematik",
           params: {
             tahun_asal: tahun_asal,
             tahun_tujuan: tahun_tujuan
           }
      jumlah_setelah_clone = jumlah_awal * 2
      pohon_count = Pohon.count

      expect(pohon_count).to eq(jumlah_setelah_clone)
      expect(response.body).to include("Pohon di clone")
    end

    it 'should not change source tema' do
      tahun_asal = '2023'
      tahun_tujuan = kelompok_anggaran.id
      pohon_asli = pohon
      pohon_child1
      pohon_child12
      pohon_child2
      pohon_child22
      pohon_child23
      pohon_child3
      pohon_child31
      pohon_child4

      post "/clone/#{pohon_asli.id}/pohon_tematik",
           params: {
             tahun_asal: tahun_asal,
             tahun_tujuan: tahun_tujuan
           }
      new_pohon = Pohon.find_by(tahun: '2023_perubahan', pohonable_type: 'Tematik')
      # expect(new_pohon.pohonable.tahun).to eq('2023_perubahan')
      # pohon_tematik = PohonTematikQueries.new(tahun: '2023_perubahan')
      # expect(pohon_tematik.sub_tematiks.size).to eq 1
      # expect(pohon_tematik.sub_sub_tematiks.size).to eq 1
      # expect(pohon_tematik.strategi_tematiks.size).to eq 1
      sub_pohon = new_pohon.sub_pohons
      expect(sub_pohon.map(&:pohonable)).to include a_kind_of(SubTematik)
      expect(sub_pohon.map(&:pohonable)).to include a_kind_of(SubSubTematik)
      expect(sub_pohon.map(&:pohonable)).to include a_kind_of(Strategi)
    end
  end
end
