# frozen_string_literal: true

class ButtonLinkComponent < ViewComponent::Base
  def initialize(path: '', text: 'Show', title: 'Preview')
    super
    @path = path
    @text = text
    @title = title
  end

  erb_template <<~ERB
    <%= link_to @path,
        target: "_blank",
        rel: "nofollow",
        class: "btn btn-sm btn-primary",
        title: @title,
        data: {
            bs_toggle: 'tooltip',
            bs_placement: 'bottom',
       } do %>
        <i class="fas fa-book-open me-2"></i>
        <%= @text %>
        <% end %>
  ERB
end
