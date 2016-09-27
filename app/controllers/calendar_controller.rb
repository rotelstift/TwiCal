require 'date'

class CalendarController < ApplicationController
  def home

    # 今日の日付を設定する
    @now = Date.today

    # 月初めの日付と月終わりの日付を設定する。
    @beginning_of_month = @now.beginning_of_month
    @end_of_month = @now.end_of_month

    @calendar = set_calendar(@beginning_of_month, @end_of_month)

  end

  def set_calendar(beginning, ending)
    calendar_ary = Array.new

    start = beginning.beginning_of_week
    last = ending.end_of_week

    for d in start..last do
      calendar_ary.push(d)
    end

    return calendar_ary

  end

end
