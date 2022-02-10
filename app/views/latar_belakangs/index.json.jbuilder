# json.array! @latar_belakangs, partial: "latar_belakangs/latar_belakang", as: :latar_belakang
json.results @latar_belakangs do |lb|
  json.id lb.id
  json.text lb.dasar_hukum.body.to_html
end
