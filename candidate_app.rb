require "./boot.rb"

class CandidateApp < Sinatra::Base
  register Padrino::Helpers
  enable :sessions
  set :session_secret, 'bedxpokwvgfmn'

  get '/' do
    erb :index
  end

  get '/check' do
    Candidate.count.to_s
  end

  if "development" == ENV["RACK_ENV"]
    get '/auth/fake' do
      session[:candidate] = Candidate.where(email: "tim@lossen.de").first
      redirect '/me'
    end 
  end

  get '/auth/github' do
    redirect(github_client.auth_code.authorize_url)
  end

  get '/auth/github/callback' do
    redirect "/" if params[:error]
    access_token = github_client.auth_code.get_token(params[:code])
    puts "token: #{access_token.token}"
    user = JSON.parse(access_token.get('/user').body)
    candidate = Candidate.where(email: user["email"]).first
    if candidate
      session[:candidate] = candidate
      redirect "/me"
    else
      session[:auth] = Hash[
        name: user["name"],
        email: user["email"],
        referrer: session[:referrer]
      ]
      session[:location] = user["location"]
      redirect "/signup/new"
    end
  end

  get '/signup/new' do
    ensure_authorized
    @form = Form.new("/signup/")
    @form.params[:location] = session[:location]
    erb :candidate
  end

  get '/signup/' do
    ensure_authorized
    @form = session[:form]
    erb :candidate
  end

  post '/signup/' do
    ensure_authorized
    form = session[:form] = CandidateForm.new("/signup/", params)
    if form.errors.empty?
      session[:candidate] = Candidate.create(form.result.merge(session[:auth]))
      redirect '/me'
    else
      redirect '/signup/'
    end
  end

  get '/me' do
    ensure_candidate
    @candidate = session[:candidate]
    erb :profile
  end

  get '/edit/:new?' do
    ensure_candidate
    @form = params[:new] ? CandidateForm.create("/edit/", session[:candidate]) : session[:form]
    erb :candidate
  end

  post '/edit/' do
    ensure_candidate
    form = session[:form] = CandidateForm.new("/edit/", params)
    if form.errors.empty?
      session[:candidate].update_attributes(form.result)
      redirect '/me'
    else
      redirect '/edit/'
    end
  end

  get '/invite/:code' do
    referrer = Candidate.where(ref_code: params[:code]).first
    session[:referrer] = referrer.email if referrer
    redirect '/'
  end

  def ensure_authorized
    redirect '/auth/github' and return unless session[:auth]
  end

  def ensure_candidate
    redirect '/auth/github' and return unless session[:candidate]
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
    clazz = @form.errors.include?(name) ? %q{ class="with-error"} : ""
    "<h3#{clazz}>#{text}</h3>"
  end

  def ref_link(candidate)
    "http://app.unobtanium.cc/invite/#{candidate.ref_code}"
  end

end

