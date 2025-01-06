# frozen_string_literal: true

class DeleteRowButtonComponent < ViewComponent::Base
  def initialize(path: '', message: 'Hapus ?', title: 'Hapus', data_attr: {}, data_action: '', style: '', icon: nil)
    super
    @title = title
    @path = path
    @message = message
    @data_attr = data_attr
    @data_action = data_action
    @style = style
    @icon = icon
  end

  def style
    default_style = ['btn btn-sm btn-outline-danger']
    default_style << @style
    default_style.join(' ')
  end

  def icon
    default_icon = @icon || 'fas fa-trash-alt'
    "<span class='#{default_icon} me-2'></span>".html_safe
  end

  def data_actions
    base_actions = ['ajax:complete->row#deleteRow:prevent']
    base_actions << @data_action
    base_actions.join(' ')
  end

  def data_attrs
    base_attr = {
      confirm_swal: 'Konfirmasi Aksi',
      text: @message,
      action: data_actions
    }
    base_attr.merge(@data_attr)
  end

  def attrs
    {
      method: :delete,
      remote: true,
      class: style,
      data: data_attrs
    }
  end
end
