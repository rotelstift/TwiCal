class DropTweetsByDay < ActiveRecord::Migration
  def change
    drop_table :tweets_by_day
  end
end
