class CallbackController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  URL = 'https://manekin.madiunkota.go.id/oauth/token'.freeze
  URL_USER = 'https://manekin.madiunkota.go.id/api/user'.freeze

  def index
    ctx = OpenSSL::SSL::SSLContext.new
    ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
    code = params[:code]
    param_sso = {
      grant_type: 'authorization_code',
      client_id: '97dd802d-9840-4f0b-98c1-96fb80dc7b92',
      client_secret: 'X2a71ep0QzpuvEBjjvTQzTv7A7J7Z7CWpunZbTJw',
      redirect_uri: callback_path,
      code: code,
      scope: '*'
    }
    logger = Logger.new(STDOUT)
    http = HTTP.use(logging: { logger: logger })

    response = http.post(URL, form: param_sso, ssl_context: ctx)

    data = JSON.parse response.body.to_s
    access_token = data['access_token']
    user_login(access_token)
  rescue StandardError
    redirect_to root_path, alert: 'Terjadi Kesalahan'
  end

  def user_login(access_token)
    ctx = OpenSSL::SSL::SSLContext.new
    ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
    logger = Logger.new(STDOUT)
    http = HTTP.use(logging: { logger: logger })
    # api user
    response = http.auth("Bearer #{access_token}").get(URL_USER, form: {}, ssl_context: ctx)
    user_data = JSON.parse response.body.to_s
    username = user_data['username']
    user = User.find_by(nik: username)
    sign_in(user)
    redirect_to root_path, success: 'Login via MANEKIN'
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'User Tidak ditemukan'
  end
end
