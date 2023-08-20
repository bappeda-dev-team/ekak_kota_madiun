class TimsController < ApplicationController
  def index
    @tims = Tim.all
  end

  def new
    @tim = Tim.new
    render layout: false
  end
end
