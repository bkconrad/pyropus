# module for querying New York Times' congress API
# depends on the Bill model and 'json' gem
require 'net/http'
module NytCongress

  def recent_bills
    api_version = "v3"
    api_key = "b8ba79c23fb90f20c144b168f24a1e45:14:65821016"
    api_host = "http://api.nytimes.com/"
    api_path = "svc/politics/#{api_version}/us/legislative/congress"
    api_format = "json"
    congress_number = 112
    chamber = "house"

    # introduced | updated | passed | major
    type = "introduced"
    bills_path = "#{api_path}/#{congress_number}/#{chamber}/bills/#{type}.#{api_format}"
    query_params = { "api-key" => api_key } 
    uri = URI(api_host + bills_path)
    uri.query = URI.encode_www_form query_params
    response = Net::HTTP.get(uri)

    json = ActiveSupport::JSON.decode(response)
    return json["results"][0]["bills"]
  end
end
