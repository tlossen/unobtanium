require "bundler/setup"
require "sinatra/base"
require "padrino-helpers"
require "oauth2"
require "json"

require "mongoid"
Mongoid.load!("config/mongoid.yml", :production)

$:.unshift Dir.pwd + "/lib"
require "forms"
require "token"
require "candidate"

