# module for querying New York Times' congress API
# depends on the Bill model
require 'net/http'
module NytCongress
  CURRENT_SESSION = 112

  def recent_bills

    # introduced | updated | passed | major
    type = "introduced"
  end

  # return true if the passed string looks like a bill id
  def bill_id? arg
    /(hr|s)\d*\Z/ =~ arg
  end

  def recent_bills (chamber, type)
    result = run_query "#{NytCongress::CURRENT_SESSION}/#{chamber}/bills/#{type}.json"
    result["results"][0]["bills"]
  end

  def bill_details (chamber, bill_id)
  end

  # query_path must include everything after /congress/
  def run_query (query_path)
    api_version = "v3"
    api_host = "http://api.nytimes.com/svc/politics/#{api_version}/us/legislative/congress/"
    api_key = "b8ba79c23fb90f20c144b168f24a1e45:14:65821016"

    query_params = { "api-key" => api_key } 
    uri = URI(api_host + query_path)
    uri.query = URI.encode_www_form query_params
    response = Net::HTTP.get(uri)

    json = ActiveSupport::JSON.decode(response)
    return json
  end
end
