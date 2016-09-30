require 'twitter'
require 'date'

module TweetsModule

  def user_timeline(calendar, display_time)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.twitter_api_key
      config.consumer_secret = Rails.application.secrets.twitter_api_secret
      config.access_token = session[:oauth_token]
      config.access_token_secret = session[:oauth_token_secret]
    end

    @tweets = Array.new
    @tweet_counts_of_day = Array.new

    (1..display_time.end_of_month.day).each do |day|
      @tweet_counts_of_day[day] = 0
      @tweets[day] = []
    end

    #client.search("", {from: current_user, since: Date.today.beginning_of_month}).each do |tweet|
    client.user_timeline(count: 200).each do |tweet|
      text = tweet.full_text
      date_time = tweet.created_at

      if date_time.month == display_time.month then
        @tweet_counts_of_day[date_time.day] += 1

        @tweets[date_time.day].push({text: text, date_time: date_time})
      end
    end

  end
end
