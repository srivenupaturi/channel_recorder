class User < ActiveRecord::Base
  attr_accessible :email, :fname, :lname, :password
  has_many :recording_events
end
