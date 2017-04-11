module TweetsModule
  require 'twitter'
  require 'date'
  require 'rinku'

  TWEETS_TO_GET = 100


  # 今月分のツイートをとってくる関数
  # リファクタリングしたい
  #
  # 方針としては、まず変則2重ループとなっている構造をなくす
  # そのために、ループ1とループ2に分ける


  def tweets_in_this_month(display_time, current_user)

    # 今月のツイートを入れる配列。二次元配列になっていて、
    # tweets_in_this_month[day][n_tweets]となり、
    # n_tweetsにはハッシュで書き込みなどが入っている。
    tweets_in_this_month = Array.new(display_time.end_of_month.day+1){Array.new()}

    # @current_user = current_user
    tweet_db = TweetDb.new
    tweet_db.user = current_user
    # tweet_db.datetime = DateTime.now
    # timelineの初期化
    timeline = nil

    # もしdisplay_timeに近い時間のtweet_idがセットされていたら
    # それを読み込んでuser_timelineに渡したいなぁ。。。
    tweet_id = tweet_db.get_nearest_tweet(display_time, current_user.id)

    # 読み込んだ中で最古のtweetの日付が表示したい日付の月初めより
    # 新しい場合にのみループする関数
    begin
      if timeline then
        # timeline.last.idだけを引数にすると、無限ループになる場合がある
        # timeline = user_timeline(TWEETS_TO_GET, (timeline.last.id.to_i - 1).to_s)
        timeline = timeline + user_timeline(TWEETS_TO_GET, tweet_db.rounding_id(timeline.last.id))
      elsif !tweet_id.blank?
        timeline = user_timeline(TWEETS_TO_GET, tweet_db.rounding_id(tweet_id))
      else
        timeline = user_timeline(TWEETS_TO_GET)
      end

      if timeline == [] then
        p 'timeline is []'
        break
      end
    end while (timeline.last.created_at >= display_time.beginning_of_month)



    timeline.each do |tweet|
      if (tweet.created_at.year == display_time.year) && (tweet.created_at.month == display_time.month) then

        tweets_in_this_month[tweet.created_at.day].push({
          text:      Rinku.auto_link(tweet.full_text, :all, 'target="blank"'),
          date_time: tweet.created_at,
          screen_name: tweet.user.screen_name,
          id:        tweet.id,
          tweet_url: tweet.url.to_s
        })
      end
    end


    for i in 1..display_time.end_of_month.day do
      #binding.pry
      tweet_db.set_day_tweets(tweets_in_this_month[i], current_user.id)
      if tweets_in_this_month[i].last then
        tweet_db.set_older_tweet(tweets_in_this_month[i].last, current_user.id)
        #break
      end
    end
    return tweets_in_this_month
  end

  private

  def user_timeline(count, tweet_id = nil)

    client = create_client

    if tweet_id
      # t_debug = client.user_timeline(count: count, max_id: tweet_id)
      # Rails.logger.debug(t_debug)
      # return t_debug
      return client.user_timeline(count: count, max_id: tweet_id)
    else
      # t_debug = client.user_timeline(count: count)
      # Rails.logger.debug(t_debug)
      # return t_debug
      return client.user_timeline(count: count)
    end
  end

  def create_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.twitter_api_key
      config.consumer_secret = Rails.application.secrets.twitter_api_secret
      config.access_token = session[:oauth_token]
      config.access_token_secret = session[:oauth_token_secret]
    end
    return client
  end

end
