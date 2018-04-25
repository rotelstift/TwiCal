class RenameTweetsByMonthsToTweetDbs < ActiveRecord::Migration
  def change
    rename_table :tweets_by_months, :tweet_dbs
  end
end
