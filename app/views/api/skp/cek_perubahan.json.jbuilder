json.message "Data Perubahan Sasaran Kinerja dan User EKAK"
json.data do
  json.nama_asn @response[:nama]
  json.nip @response[:nip]
  json.tahun      @response[:tahun]
  json.kode_opd   @response[:kode_opd]
  json.opd        @response[:opd]
  json.jumlah_sasaran @response[:jumlah_sasaran]
  json.sasaran_asn @response[:perubahans]
end
