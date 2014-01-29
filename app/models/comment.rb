class Comment
	include Mongoid::Document
	include Mongoid::Timestamps

	field :body, type: String
	field :abusive, type: Boolean, default: false

	belongs_to :user
	belongs_to :post

	has_many :votes


	def has_voted? user
		votes.map(&:user_id).include?(user_id)
	end
end
