require "bundler/setup"
require "sinatra/base"
require 'padrino-helpers'

load "lib/boot.rb"


class Form
  attr_reader :params, :errors

  def initialize(params = nil)
    params ||= {}
    @params = Hash[params.to_a.map { |k,v| [k.to_sym, v] }]
    @errors = []
  end
end

class Signup < Form
  def initialize(params)
    super
    @errors << "Please enter a valid email" unless email =~ /^.+\@.+\.\w+$/
  end

  def email
    (params[:email] || "").strip
  end
end

class Signup2 < Form
  def initialize(params)
    super
    p @params
    @errors << "Please enter 'Job Title'" if job_title.empty?
    @errors << "Please select 'Company Age'" if company_age.empty?
  end

  def job_title
    (params[:job_title] || "").strip
  end

  def company_age
    values = []
    values << 'baby' if params[:company_age_baby]
    values << 'toddler' if params[:company_age_toddler]
    values << 'child' if params[:company_age_child]
    values
  end
end


class CandidateApp < Sinatra::Base
  register Padrino::Helpers
  enable :sessions
  set :session_secret, 'yadayadax'

  get '/' do
    erb :index
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

