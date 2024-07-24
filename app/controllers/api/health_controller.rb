class Api::HealthController < ActionController::API
  respond_to :json

  def index
    render json: { status: 'online' }, status: 200
  end
end
