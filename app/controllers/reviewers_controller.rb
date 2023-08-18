class ReviewersController < ApplicationController
  def index
    @reviewers = User.reviewer
  end
end
