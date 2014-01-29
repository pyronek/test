class CommentsController < ApplicationController
	before_filter :authenticate_user!

	expose(:post)
	expose(:comments) {post.comments}
	expose(:comment)
	expose(:votes) {comment.votes}

	def index
	end

	def new
	end

	def edit
	end

	def update
    if comment.save
      render action: :index
    else
      render :new
    end
  end

	def destroy
    comment.destroy if current_user.owner? comment
    render action: :index
	end

	def show
	end

	def mark_archived
	    comment.archive!
	    render action: :index
	end

	def create
		if comment.save
			render_to action: :index
		else
			render :new
		end

	end
	
	def mark_as_not_abusive
		comment.update_attribute(:abusive, false)
		redirect_to post
	end

	def vote_up
		if !comment.has_voted?(current_user)
			vote = votes.build(user_id: current_user.id, value: 1)
			respond_to do |format|
				if vote.save
					format.html {redirect_to post}
					format.js
				end
			end
		else
			render :show
		end
	end

end
