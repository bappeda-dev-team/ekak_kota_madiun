module UsersHelper
  def nama_asn(nik:)
    User.find_by(nik: nik)&.nama
  end
end
