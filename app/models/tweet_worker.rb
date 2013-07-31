class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    user = tweet.user
    client = Twitter::Client.new(:consumer_key => ENV['TWITTER_KEY'], :consumer_secret => ENV['TWITTER_SECRET'], :oauth_token => user.oauth_token, :oauth_token_secret => user.oauth_secret)
    client.update(tweet.text) 
  end

end
