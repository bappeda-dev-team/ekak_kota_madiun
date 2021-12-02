module ApplicationHelper
  def add_koefisiens(name, f, association)
    ## create new object from the association
    new_object = f.object.send(association).klass.new

    ## create or take id from the new created obejct
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
      end
    ## pass down the link to the fields form
    link_to(name, '#', class: 'add_fields', data: {id: id, fields: fields.gsub("\n", "")})
  end

end
