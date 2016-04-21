require 'pry'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDERR)


require './db_config'
require './models/user'
require './models/comment'
require './models/photo'
require './models/like'


binding.pry
