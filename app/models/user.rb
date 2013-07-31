class User < ActiveRecord::Base
  has_many :tweets

  def tweet(text)
    tweet = self.tweets.create!(:text => text)
    TweetWorker.perform_async(tweet.id)
  end

end
