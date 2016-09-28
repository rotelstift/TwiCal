require 'date'

class CalendarController < ApplicationController
  def home

    # 今日の日付を設定する
    @display_time = Date.today

    # 月初めの日付と月終わりの日付を設定する。
    @beginning_of_month = @display_time.beginning_of_month
    @end_of_month = @display_time.end_of_month

    @calendar = set_calendar(@beginning_of_month, @end_of_month)

  end

  def calendar
    # 表示したい日付を設定する
    @display_time = Date.parse(params[:display_time])

    # 月初めの日付と月終わりの日付を設定する。
    @beginning_of_month = @display_time.beginning_of_month
    @end_of_month = @display_time.end_of_month

    @calendar = set_calendar(@beginning_of_month, @end_of_month)
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

end
