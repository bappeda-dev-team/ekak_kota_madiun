json.results @domains do |domain|
  json.id domain.domain
  json.text domain.domain
end
