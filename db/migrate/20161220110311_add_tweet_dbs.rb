class AddTweetDbs < ActiveRecord::Migration
  def change
    create_table :tweet_dbs do |t|
      t.datetime :datetime, null: false
      t.string   :tweet_id, null: false
      t.integer  :user_id, null: false
      t.string   :tweet_url, null: false

      t.timestamps null: false
    end
  end
end
