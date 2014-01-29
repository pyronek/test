class Vote
	include Mongoid::Document

	after_create :make_it_abusive

	belongs_to :user
	belongs_to :comment

	field :value,  type: Integer

	private
		def make_it_abusive 
			if self.comment.votes.where(value: -1).count > 2 
				self.comment.update_attribute(:abusive, true)
			end 
		end
		
end
