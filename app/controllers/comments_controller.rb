class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @anggaran_id = params[:anggaran_id]
    @user_id = params[:user_id]
    puts 'here'
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def create
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.js
      else
        format.js { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])
    # respond_to :js if @comment.update(comment_params)
    respond_to do |format|
      if @comment.update(comment_params)
        format.js
      else
        format.js { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, success: 'komentar dihapus') }
      format.json { head :no_content }
    end
  end

  private

  def comment_params
    params.require(:comment).permit!
  end
end
