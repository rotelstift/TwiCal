require 'twitter'

#class TweetsController < ApplicationController
module TweetsModule

  def user_timeline
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.twitter_api_key
      config.consumer_secret = Rails.application.secrets.twitter_api_secret
      config.access_token = session[:oauth_token]
      config.access_token_secret = session[:oauth_token_secret]
    end

    @tweets = Array.new

    client.user_timeline(count: 10).each do |tweet|
      text = tweet.full_text
      @tweets.push(text)
    end

  end
end
