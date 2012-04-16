require 'rubygems'
require 'bundler'
Bundler.require

require 'active_support/core_ext/object'

get '/' do
  slim :index
end

post '/authenticate' do
  session[:client_id]     = params[:client_id]
  session[:client_secret] = params[:client_secret]

  client = OAuth2::Client.new(
    params[:client_id],
    "",
    response_type: "code",
    site:          "https://accounts.google.com",
    ssl:           true,
    authorize_url: "https://accounts.google.com/o/oauth2/auth"
  )

  redirect client.auth_code.authorize_url(redirect_uri: "https://google-oauth2.herokuapp.com/oauth2callback",
                                          scope:         params[:scope].presence || "https://www.googleapis.com/auth/analytics.readonly",
                                          access_type:   "offline")
end

get '/oauth2callback' do
  @code = params[:code]

  slim :callback
end
