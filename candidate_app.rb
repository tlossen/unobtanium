require "./boot.rb"

class CandidateApp < Sinatra::Base
  register Padrino::Helpers
  enable :sessions
  set :session_secret, 'bedxpokwvgfmn'

  get '/' do
    @candidate = Candidate.first
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
    session[:auth] = Hash[
      name: user["name"],
      email: user["email"],
      location: user["location"]
    ]
    candidate = Candidate.where(email: user["email"]).first
    if candidate
      session[:candidate] = candidate
      redirect "/profile"
    else
      redirect "/signup/new"
    end
  end

  get '/signup/:new?' do
    ensure_authorized
    @form = params[:new] ? Form.new("/signup/") : session[:form]
    erb :signup
  end

  post '/signup/' do
    ensure_authorized
    form = session[:form] = Signup.new("/signup/", params)
    if form.errors.empty?
      session[:candidate] = Candidate.create(form.result.merge(session[:auth] || {}))
      redirect '/profile'
    else
      redirect '/signup/'
    end
  end

  get '/profile' do
    ensure_authorized
    @candidate = session[:candidate]
    erb :profile
  end

  get '/edit/:new?' do
    ensure_authorized
    @form = params[:new] ? Signup.create("/edit/", session[:candidate]) : session[:form]
    erb :signup
  end

  post '/edit/' do
    ensure_authorized
    form = session[:form] = Signup.new("/edit/", params)
    if form.errors.empty?
      session[:candidate].update_attributes(form.result)
      redirect '/profile'
    else
      redirect '/edit/'
    end
  end

  def ensure_authorized
    redirect '/auth/github' and return unless session[:auth]
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

