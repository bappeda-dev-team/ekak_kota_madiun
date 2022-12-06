class CallbackController < ApplicationController
  def index
    client.auth_code.get_token(params[:code], redirect_uri: 'https://kak.madiunkota.go.id')
  end

  def client
    @client ||= OAuth2::Client.new(
      "97dd802d-9840-4f0b-98c1-96fb80dc7b92",
      "X2a71ep0QzpuvEBjjvTQzTv7A7J7Z7CWpunZbTJw",
      authorize_url: "/oauth/authorize",
      site: "https://manekin.madiunkota.go.id"
    )
  end
end
