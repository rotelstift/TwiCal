require 'rails_helper'
require 'date'

describe TweetDb do
  # 2＋1は3であること
  it "adds 2 and 1 to make 3" do
    expect(2 + 1).to eq  3
  end
  # datetimeが入っていること
  it "do exist datetime" do
    tweet_db = TweetDb.new(
      datetime: Date.today
    )
    expect(tweet_db).to be_valid
  end
  # tweet_idが入っていること
  it "do exist tweet_id" do
    tweet_db = TweetDb.new(
      tweet_id: nil
    )
    tweet_db.valid?
    expect(tweet_db.errors[:tweet_id]).to include("can't be blank")
  end
  # user_idが入っていること
  it "do exist user_id"
  # tweet_urlが入っていること
  it "do exist tweet_url"
  # tweet_idがユニークであること
  it "is unique in tweet_id"
  # tweet_urlがユニークであること
  it "is unique in tweet_url"
end
