class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :email, type: String
  field :passhash, type: String
  field :confirmation_code, type: String, default: ->{ Token.create }
  field :confirmed, type: Boolean, default: false
  field :name, type: String
end

class Candidate < User
  has_many :dialogs
end

class Recruiter < User
  belongs_to :company
  has_many :dialogs
end

class Company
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  has_many :recruiters
  field :name, type: String
end

class Dialog
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  belongs_to :candidate
  belongs_to :recruiter
  embeds_many :messages
  field :updated_at, type: Time
end

class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  embedded_in :dialog
  field :out, type: Boolean
  field :text, type: String
end

