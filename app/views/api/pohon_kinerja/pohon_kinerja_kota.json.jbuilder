json.results do
  json.data do
    json.tahun @tahun
    json.tematiks @tema do |tema|
      json.partial! 'pohon', locals: { tema: tema }

      json.sub_tematiks(@sub_tematiks.select { |sub| sub.pohon_ref_id == tema.id }) do |sub_tema|
        json.partial! 'pohon', locals: { tema: sub_tema }

        json.sub_sub_tematiks(@sub_sub_tematiks.select { |sub| sub.pohon_ref_id == sub_tema.id }) do |sub_sub|
          json.partial! 'pohon', locals: { tema: sub_sub }

          strategi_sub_sub_tema = @strategics.select { |str| str.pohon_ref_id == sub_sub.id }
          json.partial! 'pohon_opds',
                        locals: { strategics: strategi_sub_sub_tema, tacticals: @tacitcals,
                                  operationals: @operationals }
        end

        strategi_sub_tema = @strategics.select { |str| str.pohon_ref_id == sub_tema.id }
        json.partial! 'pohon_opds',
                      locals: { strategics: strategi_sub_tema, tacticals: @tacitcals, operationals: @operationals }
      end

      strategi_tema = @strategics.select { |str| str.pohon_ref_id == tema.id }
      json.partial! 'pohon_opds',
                    locals: { strategics: strategi_tema, tacticals: @tacitcals, operationals: @operationals }
    end
  end
end
