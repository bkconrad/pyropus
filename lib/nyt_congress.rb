# module for querying New York Times' congress API
# depends on the Bill model
require 'net/http'
module NytCongress
  CURRENT_SESSION = 112

  # returns nil if passed string looks nothing like a bill id,
  # returns the bill id otherwise.
  def bill_id? arg
    result = /(hr|hres|s|sres)\d{1,4}/.match(arg).to_s
    if result == ""
      return nil
    end
    result
  end

  def recent_bills (chamber, type)
    is_chamber = ["house","senate"].include?(chamber)
    is_valid_type = ["introduced","passed","updated","major"].include?(type)
    return nil unless(is_chamber && is_valid_type)
    result = run_query "#{NytCongress::CURRENT_SESSION}/#{chamber}/bills/#{type}.json"
    result["results"][0]["bills"]
  end

  def bill_details (bill_id, *args)
    return nil unless bill_id? bill_id
    result = run_query "#{NytCongress::CURRENT_SESSION}/bills/#{bill_id}.json"
    result["results"][0]
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
