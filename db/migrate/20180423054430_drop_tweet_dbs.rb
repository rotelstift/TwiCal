class DropTweetDbs < ActiveRecord::Migration
  def change
    drop_table :tweet_dbs
  end
end
