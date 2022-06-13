json.results @users do |user|
  json.id user.nik
  json.text "#{user.nik} - #{user.nama}"
end
