class CallbackController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  URL = 'https://manekin.madiunkota.go.id/oauth/token'.freeze
  URL_USER = 'https://manekin.madiunkota.go.id/api/user'.freeze
  H = HTTP.accept(:json)

  def index
    response = H.post(URL,
                      form: { grant_type: 'authorization_code',
                              client_id: '97dd802d-9840-4f0b-98c1-96fb80dc7b92',
                              client_secret: 'X2a71ep0QzpuvEBjjvTQzTv7A7J7Z7CWpunZbTJw',
                              redirect_uri: 'https://kak.madiunkota.go.id/callback',
                              code: params[:code] })
    data = Oj.load(response.body)
    access_token = data['access_token']

    # api user
    user_response = H.auth("Bearer #{access_token}").get(URL_USER)
    user_data = Oj.load(user_response.body)
    username = user_data['username']
    logger.debug "params_code -> #{params[:code]}"
    logger.debug "username -> #{username}"
    user = User.find_by(nik: username)
    respond_to do |format|
      if sign_in(user)
        format.html { redirect_to root_path, success: 'Login Menggunakan MANEKIN' }
      else
        format.html { redirect_to root_path, error: 'NIP Tidak ditemukan' }
      end
    end
  rescue StandardError
    logger.error "error authorization"
    redirect_to root_path
  end
end
