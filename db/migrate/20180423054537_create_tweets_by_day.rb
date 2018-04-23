class CreateTweetsByDay < ActiveRecord::Migration
  def change
    create_table :tweets_by_day do |t|
      t.datetime :tweeted_day, null: false
      t.integer  :user_id, null: false
      t.binary   :tweet_urls

      t.timestamps null: false

    end
  end
end
