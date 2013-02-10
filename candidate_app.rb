require "bundler/setup"
require "sinatra/base"
require 'padrino-helpers'
require 'oauth2'
require 'json'

load "lib/boot.rb"



class CandidateApp < Sinatra::Base
  register Padrino::Helpers
  enable :sessions
  set :session_secret, 'yadayadax'

  def new_client
    OAuth2::Client.new('77c712b815c7ce3ec6e2', '675e7872c077ed2b2907e7752ae9cd7b2f87176b',
      :site => 'https://api.github.com',
      :authorize_url => 'https://github.com/login/oauth/authorize',
      :token_url => 'https://github.com/login/oauth/access_token')
  end

  def redirect_uri(path = '/auth/github/callback', query = nil)
    uri = URI.parse(request.url)
    uri.path  = path
    uri.query = query
    uri.to_s
  end

  get '/' do
    erb :index
  end

  get '/auth/github' do
    url = new_client.auth_code.authorize_url(
      :redirect_uri => "http://app.unobtanium.cc/auth/github/callback",
      :scope => 'email'
    )
    puts "Redirecting to URL: #{url.inspect}"
    redirect url
  end

  get '/auth/github/callback' do
    puts params[:code]
    begin
      access_token = new_client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
      user = JSON.parse(access_token.get('/user').body)
      "<p>Your OAuth access token: #{access_token.token}</p><p>Your extended profile data:\n#{user.inspect}</p>"
    rescue OAuth2::Error => e
      %(<p>Outdated ?code=#{params[:code]}:</p><p>#{$!}</p><p><a href="/auth/github">Retry</a></p>)
    end
  end

  get '/signup/:new?' do
    @form = params[:new] ? Form.new : session[:form]
    erb :signup
  end

  post '/signup' do
    session[:form] = Signup.new(params)
    redirect '/signup/'
  end

  get '/signup2/:new?' do
    @form = params[:new] ? Form.new : session[:form]
    erb :signup2
  end

  post '/signup2' do
    session[:form] = Signup2.new(params)
    p ["post", session[:form]]
    redirect '/signup2/'
  end

end

