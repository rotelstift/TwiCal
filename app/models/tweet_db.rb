class TweetDb < ActiveRecord::Base
  belongs_to :user

  def set_older_tweet(tweet, user_id)
    datetime = tweet[:date_time]
    tweet_id = tweet[:id]
    # user_id = @current_user_id

    # p 'tweet_id'
    # p tweet_id

     TweetDb.find_or_create_by(tweet_id: tweet_id) do |t|
      t.datetime = datetime
      t.user_id = user_id
    end
  rescue
    return nil

  end

  def get_nearest_tweet(datetime, user_id)

    # pulls = TweetDb.where(datetime: (datetime.beginning_of_month + 1.month)..(datetime.end_of_month + 1.month), user_id: user_id)
    # TweetDb.where("datetime >= :datetime", {datetime: (DateTime.now - 1.year)}, user_id: 1).order(:datetime).limit(1)
    pulls = TweetDb.where("datetime >= :datetime", {datetime: datetime}, user_id: user_id).order(:datetime).limit(1)
    if pulls then
      p 'pulls'
      p pulls
      p 'pulls end'
    end
    return pulls.first.tweet_id
  rescue
      return nil
  end

end
