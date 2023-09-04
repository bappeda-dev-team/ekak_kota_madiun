require 'rails_helper'

RSpec.describe "PohonTematiks", type: :request do
  let(:user) { create(:user) }
  let(:tematik) { create(:tematik, tema: 'contoh', keterangan: 'contoh keterangan') }
  let(:strategi) { create(:strategi, strategi: 'contoh') }
  let(:pohon_sub_tema_params) do
    {
      pohon: {
        pohonable_id: tematik.id,
        pohonable_type: 'Tematik',
        role: 'pohon_tema_kota',
        tahun: '2023',
        keterangan: 'contoh a',
        pohon_ref_id: 20
      }
    }
  end
  let(:pohon_strategi_params) do
    {
      strategi: {
        strategi: 'strategi contoh',
        role: 'strategic_kota',
        tahun: '2023',
        sasaran_attributes: {
          sasaran_kinerja: 'contoh sasaran',
          id_rencana: 'xx1',
          indikator_sasarans_params: {
            indikator_kinerja: 'indikator',
            target: '100',
            satuan: '%',
            aspek: 'kualitas',
            sasaran_id: 'xx1'
          }
        }
      }
    }
  end
  describe "add submitted_by parameter" do
    before(:each) do
      sign_in user
    end
    it 'pohon_tematik#create' do
      post "/pohon_tematik",
           params: pohon_sub_tema_params
      pohon = Pohon.last
      expect(pohon.metadata).to include({ "submitted_by" => user.id })
    end
    it 'pohon_tematik#create_sub_tema' do
      post "/pohon_tematik/create_sub_tema",
           params: pohon_sub_tema_params
      pohon = Pohon.last
      expect(pohon.metadata).to include({ "submitted_by" => user.id })
    end
    it 'pohon_tematik#create_sub_sub_tema' do
      post "/pohon_tematik/create_sub_sub_tema",
           params: pohon_sub_tema_params
      pohon = Pohon.last
      expect(pohon.metadata).to include({ "submitted_by" => user.id })
    end
    it 'pohon_tematik#create_strategi_tematik_baru' do
      post "/pohon_tematik/create_strategi_tematik_baru",
           params: pohon_strategi_params
      pohon = Pohon.last
      expect(pohon.metadata).to include({ "submitted_by" => user.id })
    end
    it 'pohon_tematik#create_tactical_tematik_baru' do
      post "/pohon_tematik/create_tactical_tematik_baru",
           params: pohon_strategi_params
      pohon = Pohon.last
      expect(pohon.metadata).to include({ "submitted_by" => user.id })
    end
    it 'pohon_tematik#create_operational_tematik_baru' do
      post "/pohon_tematik/create_operational_tematik_baru",
           params: pohon_strategi_params
      pohon = Pohon.last
      expect(pohon.metadata).to include({ "submitted_by" => user.id })
    end
  end
end
