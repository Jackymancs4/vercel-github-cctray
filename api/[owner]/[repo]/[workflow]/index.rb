require_relative '../../../../github_to_cctray.rb'
require 'net/http'
require 'json'

Handler = Proc.new do |req, res|
  owner = req.query['owner']
  repo = req.query['repo']
  workflow = req.query['workflow']

  response = Net::HTTP.get(URI("https://api.github.com/repos/#{owner}/#{repo}/actions/workflows/#{workflow}/runs"))
  payload = JSON.parse(response)

  res.status = 200
  res['Content-Type'] = 'application/xml'
  res.body = GithubToCCTray.new.convert_to_xml(payload)
end
