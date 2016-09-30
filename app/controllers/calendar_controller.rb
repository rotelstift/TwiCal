require 'date'
include TweetsModule

class CalendarController < ApplicationController
  def home

    # 今日の日付を設定する
    @display_time = Date.today

    # 月初めの日付と月終わりの日付を設定する。
    @beginning_of_month = @display_time.beginning_of_month
    @end_of_month = @display_time.end_of_month

    @calendar = set_calendar(@beginning_of_month, @end_of_month)

    #ApplicationControllerより
    current_user

    #TweetsModuleより
    user_timeline(@calendar)

  end

  def calendar
    # 渡ってきたパラメータにvalidationをかけて、
    # 正しくなかったらrootにリダイレクトしている
    if date_valid?(params[:display_time]) then
      # 表示したい日付を設定する
      @display_time = Date.parse(params[:display_time])

      # 月初めの日付と月終わりの日付を設定する。
      @beginning_of_month = @display_time.beginning_of_month
      @end_of_month = @display_time.end_of_month

      @calendar = set_calendar(@beginning_of_month, @end_of_month)

      current_user

    else
      redirect_to(root_path)
    end
  end

  private def set_calendar(beginning, ending)
    calendar_ary = Array.new

    start = beginning.beginning_of_week
    last = ending.end_of_week

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
