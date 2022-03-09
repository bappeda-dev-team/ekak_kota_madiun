module ApplicationHelper
  def asn_sidebar_items
    [
      { title: 'Sasaran Kinerja', href: user_sasarans_path(current_user), icon: 'fas fa-bullseye',
        identifier: 'sasaran' },
      { title: 'Kak', href: kaks_path, icon: 'fas fa-sitemap', identifier: 'acuan_kerja' },
      { title: 'Laporan KaK', href: laporan_kak_path, icon: 'far fa-file', identifier: 'laporan_kak' }
    ]
  end

  def usulan_items
    [
      { title: 'Musrenbang', href: musrenbangs_path, identifier: 'musrenbang' },
      { title: 'Pokok Pikiran', href: pokpirs_path, identifier: 'pokpir' },
      { title: 'Mandatori', href: mandatoris_path, identifier: 'mandatori' },
      { title: 'Inisiatif', href: inovasis_path, identifier: 'inovasi' }
    ]
  end

  def anggaran_items
    [
      { title: 'SSH', href: anggaran_sshes_path, identifier: 'anggaran_ssh' },
      { title: 'SBU', href: anggaran_sbus_index_path, identifier: 'anggaran_sbu' },
      { title: 'HSPK', href: anggaran_hspks_path, identifier: 'anggaran_hspk' },
      { title: 'Kode Rekening', href: rekenings_path, identifier: 'rekening' }
    ]
  end

  def master_data_items
    [
      { title: 'Tematik', href: subkegiatan_tematiks_path, identifier: 'tematik', icon: 'fas fa-tags' },
      { title: 'Program', href: program_kegiatans_path, identifier: 'program_kegiatan', icon: 'fas fa-tasks' },
      { title: 'Sasaran Kinerja', href: adminsasarans_path, icon: 'fas fa-bullseye',
        identifier: 'adminsasarans' },
      { title: 'Daftar SubKegiatan OPD', href: daftar_subkegiatan_path, icon: 'fas fa-folder-open',
        identifier: 'daftar_subkegiatan' },
      { title: 'User', href: adminusers_path, icon: 'fas fa-user-check', identifier: 'adminusers' }
    ]
  end

  def navigation_class(identifier)
    return ' active' if request.path.match(/\b#{identifier}/)
  end

  def collapse_class(identifier)
    if request.path.match(/\b#{identifier}/)
      { aria: 'true', sub_menu: 'show',
        menu: '' }
    else
      { aria: 'false', sub_menu: 'collapse', menu: 'collapsed' }
    end
  end

  def status_icon(status)
    if status
      content_tag(:i, '', class: 'fas fa-check')
    else
      content_tag(:i, '', class: 'fas fa-times')
    end
  end

  def add_koefisiens(name, f, association, dc)
    ## create new object from the association
    ## dc == dynamic class for css
    new_object = f.object.send(association).klass.new

    ## create or take id from the new created obejct
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder)
    end
    ## pass down the link to the fields form
    link_to(name, '#', class: "add_fields_#{dc} btn btn-primary btn-sm",
                       data: { id: id, fields: fields.gsub("\n", '') })
  end

  def add_new_field(name, f, model, dc)
    new_obj = dc.object_id
    fields = f.text_field(model, multiple: true, value: '', class: 'form-control my-3')
    link_to(name, '#', class: "add_fields_#{dc.id}", data: { id: new_obj, fields: fields })
  end
end
