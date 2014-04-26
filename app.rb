set :mapping, host: 'h', metric: 'm', start: 'st', graph: 'g', size: 'z', cluster: 'c', range: 'r', start_time: 'cs', end_time: 'ce'

require 'net/http'
require 'sinatra/reloader' if development?
require "sinatra/config_file"
require 'slim'

set :static_cache_control, [:public, :max_age => 300]

config_file ENV["GANGLION_CONFIG"]

get '/graph/*' do
  original_params = Hash[*params[:splat].first.split("/")]
  original_params.merge!(params.reject{ |k,v| ["splat", "captures"].include?(k)})
  server_params = Hash.new.tap do |new_hash|
    original_params.each do |k,v|
      key = settings.mapping.fetch(k.to_sym, k) 
      new_hash[key] = v
    end
  end
  segment = original_params.fetch("group", "ganglia")
  uri = URI(settings.server + "#{segment}/graph.php")
  uri.query = to_params(server_params)
  p uri.to_s
  res = Net::HTTP.get_response(uri)
  cache_control :public, :must_revalidate, :max_age => 600
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
