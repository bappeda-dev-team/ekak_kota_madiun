class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show edit update destroy]
  layout false, only: %i[show new edit]

  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1 or /reviews/1.json
  def show; end

  # GET /reviews/new
  def new
    @review = Review.new(reviewable_type: params[:type],
                         reviewable_id: params[:id],
                         reviewer_id: current_user.id)
    @target = params[:target]
    @type = 'prepend'
  end

  # GET /reviews/1/edit
  def edit
    @target = params[:target]
    @type = 'replace'
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)
    if @review.save
      render json: { resText: "Review dibuat",
                     html_content: html_content({ review: @review },
                                                partial: 'reviews/review') }.to_json,
             status: :ok
    else
      render json: { resText: 'Terjadi kesalahan',
                     html_content: error_content({ review: @review },
                                                 partial: 'reviews/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    if @review.update(review_params)
      render json: { resText: "Review diperbarui",
                     html_content: html_content({ review: @review },
                                                partial: 'reviews/review') }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan",
                     html_content: error_content({ review: @review },
                                                 partial: 'reviews/form') }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy

    render json: { resText: "Review dihapus" }.to_json,
           status: :accepted
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = Review.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def review_params
    params.require(:review).permit(:keterangan,
                                   :penilaian,
                                   :reviewable_type,
                                   :reviewable_id, :reviewer_id,
                                   :kriteria_type, :kriteria_id,
                                   :status, :skor)
  end
end
