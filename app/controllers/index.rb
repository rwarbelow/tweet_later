get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  Twitter.configure do |config|
      config.oauth_token = nil
      config.oauth_token_secret = nil
    end
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)
  @user = User.find_or_create_by_username(oauth_token: @access_token.token, oauth_secret: @access_token.secret, username: @access_token.params[:screen_name])
  # at this point in the code is where you'll need to create your user account and store the access token
  session[:id] = @user.id
  erb :index
end


post '/twitter/update' do
  @user = current_user
  client = Twitter::Client.new(
  :consumer_key => ENV['TWITTER_KEY'],
  :consumer_secret => ENV['TWITTER_SECRET'],
  :oauth_token => @user.oauth_token,
  :oauth_token_secret => @user.oauth_secret
)
  client.update(params[:message])
  erb :index
  #COULDN'T MAKE WORK WITHOUT PASSING ALL PARAMS BELOW SHOULD WORK THO:
  # client = Twitter::Client.new(
  # :oauth_token => @user.oauth_token,
  # :oauth_token_secret => @user.oauth_secret
  # )
  # Thread.new{client.update(params[:message])}
end
