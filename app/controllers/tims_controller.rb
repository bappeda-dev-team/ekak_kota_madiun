class TimsController < ApplicationController
  def index
    @tims = Tim.all
  end
end
