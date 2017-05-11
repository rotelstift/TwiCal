module TweetsModule
  require 'twitter'
  require 'date'

  TWEETS_TO_GET = 200

  # 今月分のツイートをとってくる関数
  # 理想
  # 1. Twitterサーバからデータを引っ張ってくる < get_tweets_from_twitter
  # 2. Twitterから引っ張ってきたデータを加工し、DBにしまう < import_tweets
  #  2.1 Twitterから引っ張ってきたデータを加工する < processing_tweets
  #  2.2 加工したデータを日付ごとにDBにしまう < import_day_tweets
  # 3. DBからデータを呼び出して配列にしまう < pull_tweets_from_db

  def get_tweets_in_this_month(display_time, user_id, tweet_db)

    timeline = get_tweets_from_twitter(display_time, user_id, tweet_db)

    import_tweets(timeline, display_time, user_id, tweet_db)

    return pull_tweets_from_db(display_time, user_id, tweet_db)

  end

  private

  # Twitterサーバからデータを引っ張ってくる関数
  def get_tweets_from_twitter(display_time, user_id, tweet_db)

    # display_time.end_of_monthに一番近いIDをtweet_idに保存する
    tweet_id = tweet_db.get_nearest_tweet(display_time, user_id)

    # timelineの初期化
    timeline = nil

    # last_tweet_created_at_one_generation_agoの初期化
    # last_tweet_created_at_one_generation_agoはループのチェッカーとして使う
    # 初期化の場合、表示したい月の末が入る
    last_tweet_created_at_one_generation_ago = display_time.end_of_month

    # このループはまず一回は実行され、以下のいずれかの条件が満たされれば終了する
    # ・空のタイムラインがTwitterAPIから帰ってきた場合
    # ・読み込んだ中で最古のtweetの日付が表示したい日付の月初めより古い場合
    # ・読み込んだ中で最古のtweetの日付がループ一世代前の最古の日付と等しい場合
    # 最初はtimeline=nilなので、else節のどちらかに飛び、その後then節に入り、
    # 上記の条件が満たされるまでの間then節が実行され続ける。
    begin
      if timeline then
        # 今遡っている一番古いツイートの時刻を保存しておく
        last_tweet_created_at_one_generation_ago = timeline.last.created_at
        # timeline.last.idだけを引数にすると、無限ループになる場合がある
        # timeline = user_timeline(TWEETS_TO_GET, (timeline.last.id.to_i - 1).to_s)
        timeline = timeline + user_timeline(TWEETS_TO_GET, tweet_db.rounding_id(timeline.last.id))
      elsif !tweet_id.blank?
        timeline = user_timeline(TWEETS_TO_GET, tweet_db.rounding_id(tweet_id))
      else
        timeline = user_timeline(TWEETS_TO_GET)
      end
    end until ((timeline == []) ||
               (timeline.last.created_at < display_time.beginning_of_month) ||
               (timeline.last.created_at == last_tweet_created_at_one_generation_ago))

    return timeline
  end #get_tweets_from_twitter

  # Twitterから引っ張ってきたデータを加工し、DBにしまう関数
  def import_tweets(timeline, display_time, user_id, tweet_db)
    tweet_db.import_day_tweets(processing_tweets(timeline, display_time), user_id)
  end #import_tweets_of

  # DBからデータを呼び出して、二次元配列にしまう関数
  def pull_tweets_from_db(display_time, user_id, tweet_db)
    # pull_tweets[i]のなかには、i日のTweetが入る。
    # なので、31日まである月の場合、[0]~[31]までの32個分のArrayを用意して、
    # [0]は使わないことにする。なので、+1が付いている。
    # [0]には[]を入れておく。
    pull_tweets = Array.new(display_time.end_of_month.day+1) { [] }
    pull_tweets[0] = []

    tweet_db.get_month_tweets(display_time, user_id).each do |tweet|
      day = tweet.datetime.day
      pull_tweets[day] << tweet
    end

    # binding.pry

    return pull_tweets
  end #pull_tweets_from_db


  def processing_tweets(timeline, display_time)

    # 今月のツイートを入れる配列。
    tweets_in_this_month = Array.new()

    timeline.each do |tweet|
      if (tweet.created_at.year == display_time.year) && (tweet.created_at.month == display_time.month) then

        tweets_in_this_month.push({
          date_time:    tweet.created_at,
          screen_name:  tweet.user.screen_name,
          id:           tweet.id,
          tweet_url:    tweet.url.to_s
        })
      end
    end

    return tweets_in_this_month
  end #processing_tweets

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
