class User < ActiveRecord::Base
  has_many :tweets

  def tweet(text)
    tweet = self.tweets.create!(:text => text)
    TweetWorker.perform_async(tweet.id)
  end

  def tweet_later(text, minutes)
    tweet = self.tweets.create!(:text => text)
    TweetWorker.perform_in((minutes.to_i).minutes, tweet.id)
  end

end
