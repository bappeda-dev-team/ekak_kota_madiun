json.message "Data Tematik - KAK"
json.tahun @tahun
json.data do
  json.programs @tematiks do |tematik|
    json.id_tema tematik.id
    json.tematik tematik.tema
  end
end
