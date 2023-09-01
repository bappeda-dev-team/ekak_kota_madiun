require 'rails_helper'

RSpec.describe PohonCloner, type: :cloner do
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

  # trait :with_strategi
  # trait :with_strategi_sasaran
  # trait :pohon_tematik

  specify "with traits" do
    tahun_clone = '2023_perubahan'
    ket = "clone_dari_#{tahun_clone}"
    cloned_pohon = described_class.partial_apply(
      :finalize, pohon,
      traits: :pohon_tematik,
      tahun: tahun_clone,
      pohon_ref_id: '',
      keterangan: ket
    ).to_record
    expect(cloned_pohon.tahun).to eq(tahun_clone)
    expect(cloned_pohon.keterangan).to eq(ket)
    expect(cloned_pohon.metadata).to have_key("cloned_from")

    sub_pohon_clone = described_class.partial_apply(
      :finalize, pohon_child1,
      traits: :pohon_tematik,
      tahun: tahun_clone,
      pohon_ref_id: cloned_pohon.id,
      keterangan: ket
    ).to_record

    expect(pohon_child1.pohon_ref_id).not_to eq(cloned_pohon.id)
    expect(sub_pohon_clone.pohon_ref_id).to eq(cloned_pohon.id)
    expect(sub_pohon_clone.tahun).to eq(tahun_clone)
    expect(sub_pohon_clone.keterangan).to eq(ket)
    expect(sub_pohon_clone.metadata).to have_key("cloned_from")
  end
end
