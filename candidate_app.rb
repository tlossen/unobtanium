require "bundler/setup"
require "sinatra/base"
require 'padrino-helpers'

load "lib/boot.rb"


class Form
  attr_reader :errors, :values

  def initialize
    @errors = []
    @values = {}
  end
end

class Signup < Form
  def with(params)
    @errors << "invalid email" unless params[:email] =~ /^.+\@.+\.\w+$/
    @values = { :email => params[:email] }
    self
  end
end


class CandidateApp < Sinatra::Base
  register Padrino::Helpers
  enable :sessions
  set :session_secret, 'yadayada'

  get '/' do
    erb :index
  end

  get '/signup' do
    @form = session[:form] || Form.new
    erb :signup
  end

  post '/signup' do
    session[:form] = Signup.new.with(params)
    redirect '/signup'
  end

end

