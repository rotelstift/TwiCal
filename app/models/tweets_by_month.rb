class TweetsByMonth < ActiveRecord::Base
  belongs_to :user

  validates :tweeted_month, presence: true
  validates :user_id, presence: true
  
end
