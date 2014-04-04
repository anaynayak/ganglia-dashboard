set :mapping, host: 'h', metric: 'm', start: 'st', graph: 'g', size: 'z', cluster: 'c', range: 'r'

require 'net/http'
require 'sinatra/reloader' if development?
require "sinatra/config_file"
require 'slim'

set :static_cache_control, [:public, :max_age => 300]
config_file 'lib/config.yml'

get '/graph/*' do
  original_params = Hash[*params[:splat].first.split("/")]
  original_params.merge!(params.reject{ |k,v| ["splat", "captures"].include?(k)})
  server_params = Hash.new.tap do |new_hash|
    original_params.each do |k,v|
      next unless settings.mapping.has_key? k.to_sym
      new_hash[settings.mapping[k.to_sym].to_sym] = v
    end
  end
  uri = URI(settings.server)
  uri.query = to_params(server_params)
  p uri
  res = Net::HTTP.get_response(uri)
  content_type 'image/png'
  stream do |out| 
    out << res.body
  end
end

get "/dashboard" do
  opt_params = to_params(params)
  slim :index, :locals => {:opt_params => opt_params}
end

def to_params(params)
  URI.encode_www_form(params)
end
