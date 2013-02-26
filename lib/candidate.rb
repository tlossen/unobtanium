class Candidate
  include Mongoid::Document
  include Mongoid::Timestamps

  # referrals
  field :ref_code, type: String, default: ->{ Token.create }
  field :referrer, type: String

  # from github
  field :name, type: String
  field :email, type: String

  # from signup form
  field :position, type: String
  field :job_types, type: Array
  field :priorities, type: Array
  field :language, type: String
  field :traits, type: Array
  field :experience, type: Integer
  field :location, type: String

end
