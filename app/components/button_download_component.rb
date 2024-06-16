# frozen_string_literal: true

class ButtonDownloadComponent < ViewComponent::Base
  def initialize(text:, path:)
    super
    @text = text
    @path = path
  end

  def file_icon(jenis:)
    icon = if jenis == 'excel'
             "<i class='far fa-file-excel me-2'></i>"
           else
             "<i class='fas fa-file-pdf me-2'></i>"
           end
    icon.html_safe
  end

  erb_template <<~ERB
    <%= link_to @path, class: "btn btn-sm btn-outline-success" do %>
      <%= file_icon(jenis: 'excel') %>
      <%= @text %>
    <% end %>
  ERB
end
