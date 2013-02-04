class Candidate
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :email, type: String
  field :passhash, type: String
  field :confirmation_code, type: String, default: ->{ Token.create }
  field :confirmed, type: Boolean, default: false
end
