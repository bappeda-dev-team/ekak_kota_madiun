module ReviewsHelper
  def reviewer_button(item, kriteria: '', btn_name: 'Review', target: '')
    return unless reviewer?

    link_to new_review_path(type: item.class.name, id: item, kriteria: kriteria, target: target),
            remote: true,
            class: "btn btn-sm btn-outline-info",
            data: {
              controller: 'form-modal',
              action: 'ajax:complete->form-modal#success:prevent',
              bs_toggle: 'modal',
              bs_target: '#form-modal'
            } do
      "#{content_tag(:i, '', class: 'fas fa-pencil-alt me-2')} #{content_tag(:span, btn_name)}".html_safe
    end
  end
end
