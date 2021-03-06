class CommentsController < ApplicationController
	before_action :is_authenticated?, except: [:index]

	def index
    @post = Post.find params[:post_id]
  end

  def new
  	@post = Post.find params[:post_id]
  	@comment = Comment.new
  end

  def create
  	Comment.create comment_params do |c|
      c.post_id = params[:post_id]
      c.user_id = @current_user.id
      c.save
    end
    redirect_to post_comments_path(params[:post_id])
  end

    def upvote
    comment = Comment.find(params[:comment_id])
    unless comment.votes.find_by_user_id(@current_user.id)
      vote = Vote.create(value: 1, user_id: @current_user.id)
      comment.votes << vote
      flash[:success] = 'Voted!'
    else
      flash[:warning] = "You already voted!"
    end
    redirect_to post_comments_path(comment.post_id)
  end

  def downvote
    comment = Comment.find(params[:comment_id])
    vote = Vote.create(value: -1, user_id: @current_user.id)
    comment.votes << vote

    redirect_to post_comments_path(comment.post_id)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
