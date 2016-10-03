class Tweet < ActiveRecord::Base
  belongs_to :user

  #def initialize current_user_id
#    @current_user_id = current_user_id[:user_id]
  #end

  def set_older_tweet(tweet)
    datetime = tweet[:datetime]
    tweet_id = tweet[:id]
    user_id = @current_user_id

    p 'tweet_id'
    p tweet_id

     Tweet.find_or_create_by(tweet_id: tweet_id) do |t|
      t.datetime = datetime
      t.user_id = user_id
      p 'set compleate.'
    end
  rescue
    return nil

  end

  def get_older_tweet(datetime)

    pulls = Tweet.where(datetime: (datetime.beginning_of_month + 1.month)..(datetime.end_of_month + 1.month), user_id: @current_user_id)
    if pulls then
      p 'pulls'
      p pulls.first
      p 'pulls end'
    end
    return pulls.first.tweet_id
  rescue
      return nil
  end

end
