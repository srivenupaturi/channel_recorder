class User < ActiveRecord::Base
  attr_accessible :email, :fname, :lname, :password
end
