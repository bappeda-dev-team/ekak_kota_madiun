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
           tahun: '2023'
  end
  let(:pohon_child1) do
    create :pohon,
           pohonable_type: 'SubTematik',
           pohonable_id: sub_tematik.id,
           keterangan: 'pohon test 1',
           pohon_ref_id: pohon.id,
           tahun: '2023'
  end
  let(:pohon_child2) do
    create :pohon,
           pohonable_type: 'Strategi',
           pohonable_id: strategic.id,
           keterangan: 'pohon test 2',
           pohon_ref_id: pohon_child1.id,
           tahun: '2023'
  end
  let(:pohon_child3) do
    create :pohon,
           pohonable_type: 'Strategi',
           pohonable_id: tactical.id,
           keterangan: 'pohon test 3',
           pohon_ref_id: pohon_child2.id,
           tahun: '2023'
  end
  let(:pohon_child31) do
    create :pohon,
           pohonable_type: 'Strategi',
           pohonable_id: tactical2.id,
           keterangan: 'pohon test 3.1',
           pohon_ref_id: pohon_child2.id,
           tahun: '2023'
  end
  let(:pohon_child4) do
    create :pohon,
           pohonable_type: 'Strategi',
           pohonable_id: operational.id,
           keterangan: 'pohon test 4',
           pohon_ref_id: pohon_child3.id,
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
      tahun_asal = '2024'
      tahun_tujuan = kelompok_anggaran.id
      pohon_asli = pohon
      pohon_child1
      pohon_child2
      pohon_child3
      pohon_child31
      pohon_child4

      post "/clone/#{pohon_asli.id}/pohon_tematik",
           params: {
             tahun_asal: tahun_asal,
             tahun_tujuan: tahun_tujuan
           }
      new_pohon = Pohon.find_by(tahun: '2023_perubahan', pohonable_type: 'Tematik')
      expect(new_pohon.pohonable.tahun).to eq('2023_perubahan')
      sub_pohon = new_pohon.sub_pohons.pluck(:pohonable_type)
      expect(sub_pohon).to include('SubTematik')
      # sub_pohon.pohonable.update(tema: 'hasil edit berbeda')
      # expect(sub_pohon.pohonable.tema).to_not eq(pohon_child1.pohonable.tema)
    end
  end
end
