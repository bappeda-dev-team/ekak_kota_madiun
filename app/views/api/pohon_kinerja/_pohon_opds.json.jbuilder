json.strategics(strategics) do |strategic|
  json.partial! 'pohon_opd', locals: { pohon: strategic }
  json.tacticals(@tacticals.select { |tact| tact.pohon_ref_id == strategic.id }) do |tactical|
    json.partial! 'pohon_opd', locals: { pohon: tactical }
    json.operationals(@operationals.select { |op| op.pohon_ref_id == tactical.id }) do |operational|
      json.partial! 'pohon_opd', locals: { pohon: operational }
    end
  end
end
