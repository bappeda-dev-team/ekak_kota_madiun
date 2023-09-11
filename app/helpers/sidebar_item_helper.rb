module SidebarItemHelper
  def sidebar_items
    if current_user.has_role?(:super_admin) && current_user.id == 1
      render partial: 'layouts/sidebar_super_admin'
    elsif current_user.has_any_role?(:khusus)
      render partial: 'layouts/sidebar_khusus'
    elsif current_user.has_role?(:super_admin)
      render partial: 'layouts/sidebar_admin_saja'
    elsif current_user.has_role?(:admin)
      render partial: 'layouts/sidebar_admin'
    elsif current_user.has_any_role?(:reviewer, :reviewer_kak)
      render partial: 'layouts/sidebar_reviewer'
    elsif current_user.has_role?(:asn)
      render partial: 'layouts/sidebar_asn'
    else
      render partial: 'layouts/nonaktif'
    end
  end

  def status_icon(status)
    if status
      content_tag(:i, '', class: 'fas fa-check text-success')
    else
      content_tag(:i, '', class: 'fas fa-times text-danger')
    end
  end
end
