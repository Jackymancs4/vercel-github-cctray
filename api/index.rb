require 'cowsay'

Handler = Proc.new do |req, res|
  name = req.query['name'] || 'World'

  res.status = 200
  res['Content-Type'] = 'text/html; charset=UTF-8'
  res.body = Cowsay.say("Hello #{name}", 'cow')
end
