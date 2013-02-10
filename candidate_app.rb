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

  get '/' do
    erb :index
  end

  get '/auth/github' do
    redirect new_client.auth_code.authorize_url
  end

  get '/auth/github/callback' do
    begin
      access_token = new_client.auth_code.get_token(params[:code], :redirect_uri => request.url)
      puts "token: #{access_token.token}"
      @user = JSON.parse(access_token.get('/user').body)
      erb :auth
    rescue OAuth2::Error => e
      "<pre>#{e.backtrace}</pre>"
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

