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
    @kriterias = Kriterium.where(tipe_kriteria: params[:kriteria]).pluck(:kriteria, :id)
  end

  # GET /reviews/1/edit
  def edit; end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)
    @review.skor = params[:skor]
    if @review.save
      render json: { resText: "Review dibuat", html_content: html_content(@review) }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan", html_content: error_content(@review) }.to_json,
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    if @review.update(review_params)
      render json: { resText: "Review berhasil diperbarui", html_content: html_content(@review) }.to_json,
             status: :ok
    else
      render json: { resText: "Terjadi kesalahan", html_content: error_content(@review) }.to_json,
             status: :unprocessable_entity
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy

    respond_to do |format|
      format.html { redirect_to reviews_url, notice: "Review was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = Review.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def review_params
    params.require(:review).permit(:keterangan,
                                   :reviewable_type,
                                   :reviewable_id, :reviewer_id,
                                   :status, :skor, :kriteria_id)
  end

  def html_content(review)
    render_to_string(partial: 'reviews/review',
                     formats: 'html',
                     layout: false,
                     locals: { review: review })
  end

  def error_content(review)
    render_to_string(partial: 'error',
                     formats: 'html',
                     layout: false,
                     locals: { review: review })
  end
end
