require 'bundler'
Bundler.require :default
require "json"
require 'angelo/tilt/erb'
require 'angelo/mustermann'

class Server < Angelo::Base
  include Angelo::Tilt::ERB
  include Angelo::Mustermann

  get '/' do
    erb :index, locals: { host: request.headers["Host"] }
  end

  get '/background' do
    File.read(File.join("public", "4532294801_d34d36ed57_o.jpg"))
  end

  get '/sleep.js' do
    erb :sleep, locals: { host: request.headers["Host"] }
  end

  get '/delay/:seconds' do
    content_type :json
    headers['Access-Control-Allow-Origin'] = '*'

    seconds = future(:in_sec, params[:seconds]).value

    { seconds: seconds }.to_json
  end

  task :in_sec do |string|
    seconds = string.to_f

    seconds = 0 if seconds < 0
    seconds = 30 if seconds > 30

    sleep seconds

    seconds
  end
end

Server.run