require 'date'
include TweetsModule
include SessionsHelper


class CalendarController < ApplicationController
  skip_before_action :require_login, only: [:home]
  
  def home

    # 今日の日付を設定する
    @display_time = Date.current

    @calendar = set_calendar(@display_time)

    #ApplicationControllerより
    current_user

    if logged_in? then
      #TweetsModuleより
      tweet_db = TweetDb.new
      @tweets = get_tweets_in_this_month(@display_time, @current_user.id, tweet_db)

    end

  end

  def calendar
    # 渡ってきたパラメータにvalidationをかけて、
    # 正しくなかったらrootにリダイレクトしている
    #binding.pry
    if date_valid?(params[:display_time]) then
      # 表示したい日付を設定する
      @display_time = Date.parse(params[:display_time], :JST)

      @calendar = set_calendar(@display_time)

      current_user

      #binding.pry

      # if logged_in? then
        #TweetsModuleより
        tweet_db = TweetDb.new
        @tweets = pull_tweets_from_db(@display_time, @current_user.id, tweet_db)

        if @tweets.flatten.blank? then
          @tweets = get_tweets_in_this_month(@display_time, @current_user.id, tweet_db)
        end
        #binding.pry
      # end

    else
      redirect_to(root_path)
    end
  end

  def schedule
    current_user
    tweet_db = TweetDb.new
    @schedule_day = Date.parse(params[:schedule_day], :JST)
    @tweets_of_day = tweet_db.get_day_tweets(@schedule_day, @current_user.id)
    #tweet_db = nil
    #binding.pry
  end

  private def set_calendar(display_time)
    calendar_ary = Array.new

    # 月初めの日付と月終わりの日付を設定する。
    beginning_of_month = display_time.beginning_of_month
    end_of_month = display_time.end_of_month

    #カレンダーの始まりの日と終わりの日を設定する。
    start = beginning_of_month.beginning_of_week
    last = end_of_month.end_of_week

    for d in start..last do
      calendar_ary.push(d)
    end

    return calendar_ary

  end

  # 日付のvalidationを行う関数
  # strに不正な文字列が渡ってきた場合rescueが動き、
  # 不正な日付(2016-2-31など)が渡ってきた場合
  # !! Date.parse(str)でfalseが返る
  private def date_valid?(str)
    !! Date.parse(str) rescue false
  end

end
