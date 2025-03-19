# frozen_string_literal: true

class ButtonToggleHideComponent < ViewComponent::Base
  def initialize(path: '', title: '',
                 data_attr: {}, is_hidden: false, action: '')
    super
    @title = title
    @path = path
    @data_attr = data_attr
    @is_hidden = is_hidden
    @action = action
  end

  def title_btn
    prefix = @is_hidden ? 'Tampilkan' : 'Sembunyikan'

    "#{prefix} #{@title}"
  end

  def btn_style
    hidden_style = 'btn btn-sm btn-outline-info'
    shown_style = 'btn btn-sm btn-outline-danger'

    @is_hidden ? hidden_style : shown_style
  end

  def btn_icon
    hidden_style = 'fas fa-eye'
    shown_style = 'fas fa-eye-slash'

    default_icon = @is_hidden ? hidden_style : shown_style

    "<span class='#{default_icon} me-2'></span>".html_safe
  end

  def data_actions
    if @action.present?
      @action
    else
      'ajax:complete->row#deleteRow:prevent'
    end
  end

  def data_attrs
    base_attr = {
      confirm_swal: 'Konfirmasi Aksi',
      text: "#{title_btn} ?",
      action: data_actions
    }
    base_attr.merge(@data_attr)
  end

  def attrs
    {
      method: :delete,
      remote: true,
      class: btn_style,
      data: data_attrs
    }
  end
end
