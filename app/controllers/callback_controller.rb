class CallbackController < ApplicationController
  require 'net/http'

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  URL = 'https://manekin.madiunkota.go.id/oauth/token'.freeze
  URL_USER = 'https://manekin.madiunkota.go.id/api/user'.freeze
  def index
    uri = URI(URL)
    response = Net::HTTP.post_form(uri,
                                   grant_type: 'authorization_code',
                                   client_id: '97dd802d-9840-4f0b-98c1-96fb80dc7b92',
                                   client_secret: 'X2a71ep0QzpuvEBjjvTQzTv7A7J7Z7CWpunZbTJw',
                                   redirect_uri: callback_path,
                                   code: params[:code])
    logger.error "response callback -> #{response.code}"
    data = Oj.load(response.body)
    logger.error "result -> #{response}"
    logger.error "response json body-> #{data}"
    access_token = data['access_token']

    # api user
    user_response = HTTP.accept(:json).auth("Bearer #{access_token}").get(URL_USER)
    logger.error "response callback -> #{user_response.code}"
    user_data = Oj.load(user_response.body)
    logger.error "response json -> #{user_data}"
    username = user_data['username']

    user = User.find_by(nik: username)
    respond_to do |format|
      if user
        sign_in(user)
        format.html { redirect_to root_path, success: 'Login Menggunakan MANEKIN' }
      else
        format.html { redirect_to root_path, alert: 'NIP Tidak ditemukan' }
      end
    end
  end
end
