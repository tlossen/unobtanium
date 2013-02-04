require "mongoid"

Mongoid.load!("mongoid.yml", :development)

$:.unshift Dir.pwd + "/lib"

require "token"
require "candidate"

