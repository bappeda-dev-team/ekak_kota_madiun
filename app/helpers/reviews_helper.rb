module ReviewsHelper
  def reviewer_button(item, kriteria: '')
    return unless reviewer?

    link_to(new_review_path(type: item.class.name, id: item, kriteria: kriteria),
            remote: true,
            class: "btn btn-sm btn-outline-info",
            data: {
              controller: 'form-modal',
              action: 'ajax:complete->form-modal#success:prevent',
              bs_toggle: 'modal',
              bs_target: '#form-modal'
            }) do
      content_tag(:i, "", class: "fas fa-pencil-alt me-2").html_safe + ' ' +
        + content_tag(:span, "Review")
    end
  end
end
