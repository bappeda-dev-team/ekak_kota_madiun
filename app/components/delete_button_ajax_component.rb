# frozen_string_literal: true

class DeleteButtonAjaxComponent < ViewComponent::Base
  def initialize(path:, model:, text: 'Hapus Item ?')
    super
    @path = path
    @model = model
    @text = text
  end
end
