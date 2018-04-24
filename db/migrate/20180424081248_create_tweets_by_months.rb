class CreateTweetsByMonths < ActiveRecord::Migration
  def change
    create_table :tweets_by_months do |t|
      t.datetime :tweeted_month, null: false
      t.datetime :last_accessed_at, null: false
      t.integer  :user_id, null: false
      t.binary   :tweets_by_month

      t.timestamps null: false
    end
  end
end
