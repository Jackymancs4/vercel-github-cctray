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
  if github_api_token.nil?
    req['Authorization'] = "Bearer #{github_api_token}"
  end
  response = Net::HTTP.start(uri.hostname, uri.port) {|http|
    http.use_ssl = true
    http.request(req)
  }

  payload = JSON.parse(response)

  res.status = 200
  res['Content-Type'] = 'application/xml'
  res.body = GithubToCCTray.new.convert_to_xml(payload)
end
