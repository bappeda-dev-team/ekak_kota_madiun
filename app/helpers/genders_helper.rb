module GendersHelper
  def gender_items
    [
      { title: 'GAP', href: laporan_gap_genders_path, identifier: 'genders/laporan_gap' },
      { title: 'GBS', href: laporan_gbs_genders_path, identifier: 'genders/laporan_gbs' }
    ]
  end
end
