module ApplicationHelper

  def asn_sidebar_items
    [
      { title: 'Sasaran Kinerja', href: user_sasarans_path(current_user), icon: 'fas fa-bullseye', identifier: 'sasaran' },
      { title: 'Sub Kegiatan', href: program_kegiatans_path, icon: 'fas fa-tasks' , identifier: 'program_kegiatan'},
      { title: 'Kak', href: kaks_path, icon: 'fas fa-sitemap', identifier: 'acuan_kerja' },
      { title: 'Laporan KaK', href: laporan_kak_path, icon: 'far fa-file' , identifier: 'laporan_kak'},
    ]
  end

  def sub_sidebar_items
    [
      { title: 'Musrenbang', href: musrenbangs_path, identifier: 'musrenbang' },
      { title: 'Pokok Pikiran', href: pokpirs_path, identifier: 'pokpir' },
      { title: 'Mandatori', href: mandatoris_path, identifier: 'mandatori' },
      { title: 'Inovasi', href: inovasis_path, identifier: 'inovasi' },
    ]
  end

  def navigation_class(identifier)
    return ' active' if request.path.match(/\b#{identifier}/)
  end

  def add_koefisiens(name, f, association, dc)
    ## create new object from the association
    ## dc == dynamic class for css
    new_object = f.object.send(association).klass.new

    ## create or take id from the new created obejct
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
      end
    ## pass down the link to the fields form
    link_to(name, '#', class: "add_fields_#{dc} btn btn-primary btn-sm", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def add_new_field(name, f, model, dc)
    new_obj = dc.object_id
    fields = f.text_field(model, multiple: true, value: "", class: "form-control my-3" )
    link_to(name, '#', class: "add_fields_#{dc.id}", data: {id: new_obj, fields: fields})
  end
end
