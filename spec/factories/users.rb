FactoryBot.define do
  factory :user do
    nama { "NOOR AFLAH" }
    nik {"197609072003121007"}
    email {"197609072003121007@madiunkota.go.id"}
    password {"123456"}
    association :opd
  end
end
