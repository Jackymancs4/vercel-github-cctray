require_relative '../../../../github_to_cctray.rb'
require 'net/http'
require 'json'

Handler = Proc.new do |req, res|
  owner = req.query['owner']
  repo = req.query['repo']
  workflow = req.query['workflow']

  github_api_token = ENV["GITHUB_API_TOKEN"]

  uri = URI("https://api.github.com/repos/#{owner}/#{repo}/actions/workflows/#{workflow}/runs")

  req = Net::HTTP::Get.new(uri)
  unless github_api_token.nil?
    req['Authorization'] = "Bearer #{github_api_token}"
  end
  http = Net::HTTP.new(uri.hostname, uri.port)

  http.use_ssl = (uri.scheme == "https")
  response = http.request(req)

  payload = JSON.parse(response.body)

  res.status = 200
  res['Content-Type'] = 'application/xml'
  res.body = GithubToCCTray.new.convert_to_xml(payload)
end
