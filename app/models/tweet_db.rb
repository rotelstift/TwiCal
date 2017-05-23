class TweetDb < ActiveRecord::Base
  belongs_to :user

  validates :datetime, presence: true
  validates :tweet_id, presence: true
  validates :user_id, presence: true
  validates :tweet_url, presence: true

  def import_day_tweets(tweets, user_id)
    tweets.each do |tweet|
      date_time = tweet[:date_time]
      tweet_id = tweet[:id]
      tweet_url = tweet[:tweet_url]

      unless tweet_id.blank?
        TweetDb.find_or_create_by(tweet_id: tweet_id) do |t|
          t.datetime = date_time
          t.user_id = user_id
          t.tweet_url = tweet_url
        end
      else
        return nil
      end
    end
  end

  def get_day_tweets(datetime, user_id)
    pulls = TweetDb.where(datetime: (datetime.beginning_of_day)..(datetime.end_of_day), user_id: user_id).order("datetime DESC")
    #pulls = TweetDb.where(datetime: datetime.day, user_id: user_id)

    #binding.pry

    return pulls
  end

  def get_month_tweets(datetime, user_id)
    pulls = TweetDb.where(datetime: (datetime.beginning_of_month)..(datetime.end_of_month), user_id: user_id).order("datetime DESC")
    #pulls = TweetDb.where(datetime: datetime.day, user_id: user_id)

    #binding.pry

    return pulls
  end

  def set_older_tweet(tweet, user_id)
    datetime = tweet[:date_time]
    tweet_id = tweet[:id]
    tweet_url = tweet[:tweet_url]

    unless tweet_id.blank?
      TweetDb.find_or_create_by(tweet_id: tweet_id) do |t|
        t.datetime = datetime
        t.user_id = user_id
        t.tweet_url = tweet_url
      end
     else
       return nil
     end
  rescue
    return nil

  end

  def get_nearest_tweet(datetime, user_id)

    suspected_id = time2tweet_id(datetime.beginning_of_month + 1.month)
    if suspected_id
      return suspected_id
    else
      return TweetDb.where("datetime >= :datetime", {datetime: datetime}, user_id: user_id).order(:datetime).limit(1).first.tweet_id
    end
  rescue
      return 1288834974657
  end

  def rounding_id(id)
    return time2tweet_id(tweet_id2time(id))
  rescue
    return (id.to_i - 1).to_s
  end

  private def tweet_id2time(id)
    return Time.at(((id.to_i >> 22) + 1288834974657) / 1000.0)
  end

  private def time2tweet_id(time)
    # 2010年11月5日あたりにtweet_idシステムに変更が入る。
    # この関数ではその頃までしか擬似IDを作ることができないので、
    # 2011年1月1日よりも古いtimeがきたら、nilを返すことにする。
    if time > Date.new(2011, 1, 1) then
      time = DateTime.new(time.year, time.month, time.day)
      return (time.to_f * 1000 - 1288834974657).to_i << 22
    else
      return nil
    end
  end

end
