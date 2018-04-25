class TweetsByMonth < ActiveRecord::Base
  belongs_to :user

  validates :tweeted_month, presence: true
  validates :user_id, presence: true

  def set_tweet_at_month(tweets, tweeted_month, user_id)
    # tweetsを引き取り、tweeted_monthに呟かれたtweetだったら
    # 配列に入れていく
    # 配列は2重配列で、tweets_by_month[day][n] = {tweet_id, tweet_url, tweeted_at}
    # というデータ構造になっている。
    # tweets_by_month[day]は、day = 0 ~ end_of_month.dayになるようにして、
    # tweets_by_month[0]は使わない。なので配列の宣言で＋1されている。

    tweets_by_month = Array.new(tweeted_month.end_of_month.day+1) { [] }

    tweets.each do |tweet|
      if tweeted_month.beginning_of_month <= tweet.created_at && tweet.created_at < tweeted_month.end_of_month then
        tweets_by_month[tweet.created_at.day] << {tweet_id: tweet.id, tweet_url: tweet.url.to_s, tweeted_at: tweet.created_at}
      end
    end

    TweetsByMonth.find_or_create_by(tweeted_month: tweeted_month) do |t|
      t.tweeted_month = tweeted_month
      t.user_id = user_id
      t.tweets_by_month = Marshal.dump(tweets_by_month)
      t.last_accessed_at = DateTime.now
    end

  end

  def get_tweets_at_month(date, user_id)
    # return TweetsByMonth.where("date.beginning_of_month <= :tweeted_month and date.end_of_month >= :tweeted_month", {tweeted_month: date}, user_id: user_id).order(:tweeted_month)
    return TweetsByMonth.where("tweeted_month >= :tweeted_month_begin", {tweeted_month_begin: date.beginning_of_month}, user_id: user_id).order(:tweeted_month).limit(1).first

  end

  def get_nearest_tweet(datetime, user_id)
    # last_accessed_atを設定する都合上、suspected_idは使わないかも
    # とりあえず使わない設定にしておく

    #suspected_id = time2tweet_id(datetime.beginning_of_month + 1.month)
    suspected_id = nil
    if suspected_id
      return suspected_id
    else
      result = TweetsByMonth.where("tweeted_month >= :tweeted_month_begin", {tweeted_month_begin: datetime.beginning_of_month}, user_id: user_id).order(:tweeted_month).limit(1).first
      result.last_accessed_at = DateTime.now
      result.update

      return result.tweets_by_month[1][0].tweet_id
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
