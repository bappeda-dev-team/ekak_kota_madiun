json.results @users do |user|
  json.id user.nik
  json.text "#{user.nama}"
end
