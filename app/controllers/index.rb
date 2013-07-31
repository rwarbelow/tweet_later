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
  @user = User.find_or_create_by_username(@access_token.params[:screen_name])
  @user.update_attributes(oauth_token: @access_token.token, oauth_secret: @access_token.secret)
  # at this point in the code is where you'll need to create your user account and store the access token
  session[:id] = @user.id
  redirect to('/')
end


post '/twitter/update' do
  @user = current_user
  job_id = @user.tweet(params[:message])
  content_type :json
  job_id.to_json
end

post '/update_later' do 
  @user = current_user
  job_id = @user.tweet_later(params[:message], params[:minutes])
  content_type :json
  job_id.to_json
end



get '/status/:job_id' do
  job_is_complete(params[:job_id]) ? "true" : "false"
end
