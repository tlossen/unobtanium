require "mongoid"

Mongoid.load!("mongoid.yml", :development)

$:.unshift Dir.pwd + "/lib"

require "forms"
require "token"
require "candidate"

