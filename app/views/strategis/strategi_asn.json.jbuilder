json.results @strategis do |strategi|
  json.pohon_id strategi.pohon_id
  json.strategi_atasan_id strategi.strategi_ref_id
  json.strategi_dibagikan strategi.strategi_atasan.strategi
end
