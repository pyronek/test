class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable

  field :body, type: String
  field :title, type: String
  field :archived, type: Boolean, default: false

  validates_presence_of :body, :title

  belongs_to :user
  has_many :comments

  default_scope ->{ ne(archived: true) }

  def archive!
    update_attribute :archived, true
  end

  def hotness
      count = (DateTime.now - created_at.to_datetime).to_f 
      if count > 7
        count = 0
      elsif count.between?(1,3)
        count = 2   
      elsif count.between?(4,7)
        count = 1 
      elsif count < 1
        count = 3
      end
      count += 1 if comments.count >= 3
      return count

    end
end
