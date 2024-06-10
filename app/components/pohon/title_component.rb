# frozen_string_literal: true

class Pohon::TitleComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end

  def title_up
    prefix = case @title
             when 'pohon_kota'
               'Tematik Kota'
             when 'sub_pohon_kota'
               'Sub-Tematik Kota'
             when 'sub_sub_pohon_kota'
               'Sub Sub-Tematik Kota'
             when 'strategi_pohon_kota'
               'Strategic'
             else
               @title.chomp("_pohon_kota")
             end
    prefix.titleize
  end

  erb_template <<~ERB
    <div class="pohon-title">
        <h5 class="text-center"><strong><%= title_up %></strong></h5>
    </div>
  ERB
end
