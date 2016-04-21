require 'active_record'
require 'carrierwave'

#connects to different databases
options = {
  adapter: "postgresql",
  database: "pawstagram"
}

#connecting to database
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || options)
