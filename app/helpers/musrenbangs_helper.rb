module MusrenbangsHelper
  def tombol_batal
    button_to diambil_asn_musrenbang_path(musrenbang), method: :patch, remote: true, class: 'btn btn-danger d-inline-flex align-items-center toggle-active',
                                                       params: { nip_asn: nil, status: 'draft' } do
      'Batalkan' \
        '<i class="fas fa-ban text-primary icon icon-xs ms-2"></i>'
    end
  end
end
