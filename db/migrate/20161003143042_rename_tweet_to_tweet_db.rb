class RenameTweetToTweetDb < ActiveRecord::Migration
  def change
    rename_table :tweets, :tweet_dbs
  end
end
