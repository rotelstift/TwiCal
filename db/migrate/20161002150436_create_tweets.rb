class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.datetime :datetime, null: false
      t.string   :tweet_id, null: false
      t.integer  :user_id, null: false

      t.timestamps null: false
    end
  end
end
