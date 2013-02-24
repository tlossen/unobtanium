require "bundler/setup"
require "sinatra/base"
require "padrino-helpers"
require "oauth2"
require "json"

load "lib/boot.rb"

class CandidateApp < Sinatra::Base
  register Padrino::Helpers
  enable :sessions
  set :session_secret, 'yadayadax'

  get '/' do
    erb :index
  end

  get '/auth/github' do
    redirect(github_client.auth_code.authorize_url)
  end

  get '/auth/github/callback' do
    redirect "/" if params[:error]
    access_token = github_client.auth_code.get_token(params[:code])
    puts "token: #{access_token.token}"
    user = JSON.parse(access_token.get('/user').body)
    candidate = Candidate.where(:email => user["email"]).first
    if candidate
      session[:candidate] = candidate
      redirect "/profile"
    else
      session[:who] = Hash[
        name: user["name"],
        email: user["email"],
        gravatar: user["gravatar_id"],
        location: user["location"]
      ]
      redirect "/signup/new"
    end
  end

  get '/signup/:new?' do
    @who = session[:who] || {}
    @form = params[:new] ? Form.new : session[:form]
    erb :signup
  end

  post '/signup/' do
    form = session[:form] = Signup.new(params)
    if form.errors.empty?
      session[:candidate] = Candidate.create(form.result.merge(session[:who] || {}))
      redirect '/profile'
    else
      redirect '/signup/'
    end
  end

  get '/profile' do
    @candidate = session[:candidate]
    erb :profile
  end

  def github_client
    OAuth2::Client.new(
      '77c712b815c7ce3ec6e2', 
      '675e7872c077ed2b2907e7752ae9cd7b2f87176b',
      site: 'https://api.github.com',
      authorize_url: 'https://github.com/login/oauth/authorize',
      token_url: 'https://github.com/login/oauth/access_token'
    )
  end

  def field_header(name, text)
    clazz = @form.errors.include?(name) ? %q{ class="with_error"} : ""
    "<h3#{clazz}>#{text}</h3>"
  end

end

