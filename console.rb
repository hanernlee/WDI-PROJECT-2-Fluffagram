require 'pry'
require 'active_record'



# if i run anything on console it will show me the sql command on the screen
ActiveRecord::Base.logger = Logger.new(STDERR)


require './db_config'
require './models/user'
require './models/comment'
require './models/photo'
require './models/like'


binding.pry
