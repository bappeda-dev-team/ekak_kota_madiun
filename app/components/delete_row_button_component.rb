# frozen_string_literal: true

class DeleteRowButtonComponent < ViewComponent::Base
  def initialize(path: '', message: 'Hapus ?', data_attr: {}, data_action: '')
    super
    @title = 'Hapus'
    @path = path
    @message = message
    @data_attr = data_attr
    @data_action = data_action
  end

  def style
    'btn btn-sm btn-outline-danger'
  end

  def icon
    "<span class='fas fa-trash-alt me-2'></span>".html_safe
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
