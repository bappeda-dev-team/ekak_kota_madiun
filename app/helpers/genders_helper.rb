module GendersHelper
  def gender_items
    [
      { title: 'GAP', href: gap_genders_path, identifier: 'genders/gap' },
      { title: 'GBS', href: gbs_genders_path, identifier: 'genders/gbs' }
    ]
  end
end
