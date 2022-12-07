class CallbackController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  URL = 'https://manekin.madiunkota.go.id/oauth/token'.freeze
  URL_USER = 'https://manekin.madiunkota.go.id/api/user'.freeze
  def index
    ctx = OpenSSL::SSL::SSLContext.new
    ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = HTTP.accept(:json).post(URL,
                                       form: { grant_type: 'authorization_code',
                                               client_id: '97dd802d-9840-4f0b-98c1-96fb80dc7b92',
                                               client_secret: 'X2a71ep0QzpuvEBjjvTQzTv7A7J7Z7CWpunZbTJw',
                                               redirect_uri: callback_path,
                                               code: params[:code] }, ssl_context: ctx)
    data = Oj.load(response.body)
    access_token = data['access_token']
    user_login(access_token)
  rescue StandardError
    redirect_to root_path, alert: 'Terjadi Kesalahan'
  end

  private

  def user_login(access_token)
    ctx = OpenSSL::SSL::SSLContext.new
    ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # api user
    user_response = HTTP.accept(:json).auth("Bearer #{access_token}").get(URL_USER, ssl_context: ctx)
    user_data = Oj.load(user_response.body)
    username = user_data['username']
    user = User.find_by(nik: username)
    sign_in(user)
    redirect_to root_path, success: 'Login via MANEKIN'
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'User Tidak ditemukan'
  end
end
