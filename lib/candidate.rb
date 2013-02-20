class Candidate
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :referral_code, type: String, default: ->{ Token.create }

  # from github
  field :name, type: String
  field :email, type: String
  field :gravatar, type: String
  field :location, type: String

  # from signup form
  field :position, type: String
  field :job_types, type: Array
  field :priorities, type: Array
  field :language, type: String
  field :traits, type: Array
  field :experience, type: Integer
end
