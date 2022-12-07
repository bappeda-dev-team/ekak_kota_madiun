class CallbackController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  URL = 'https://manekin.madiunkota.go.id/oauth/token'.freeze
  URL_USER = 'https://manekin.madiunkota.go.id/api/user'.freeze
  def index
    begin
      response = HTTP.accept(:json).post(URL,
                                         form: { grant_type: 'authorization_code',
                                                 client_id: '97dd802d-9840-4f0b-98c1-96fb80dc7b92',
                                                 client_secret: 'X2a71ep0QzpuvEBjjvTQzTv7A7J7Z7CWpunZbTJw',
                                                 redirect_uri: 'https://kak.madiunkota.go.id/callback',
                                                 code: params[:code] })
      logger.error "response callback -> #{response.code}"
      data = Oj.load(response.body)
      logger.error "result -> #{response}"
      logger.warn "response json body-> #{data}"
      access_token = data['access_token']
    rescue StandardError
      logger.error "error authorization"
      logger.error "params_code -> #{params[:code]}"
      logger.error "token -> #{access_token}"
    end

    # api user
    begin
      user_response = HTTP.accept(:json).auth("Bearer #{access_token}").get(URL_USER)
      logger.error "response callback -> #{user_response.code}"
      user_data = Oj.load(user_response.body)
      logger.warn "response json -> #{user_data}"
      username = user_data['username']
    rescue StandardError
      logger.error "error user"
      logger.error "username -> #{username}"
    end

    user = User.find_by(nik: username)
    respond_to do |format|
      if user
        sign_in(user)
        format.html { redirect_to root_path, success: 'Login Menggunakan MANEKIN' }
      else
        format.html { redirect_to root_path, error: 'NIP Tidak ditemukan' }
      end
    end
  end
end
