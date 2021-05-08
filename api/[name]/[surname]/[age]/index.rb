require 'cowsay'

Handler = Proc.new do |req, res|
  name = req.query['name'] || 'World'
  surname = req.query['surname'] || 'Mr'
  age = req.query['age'] || '21'

  res.status = 200
  res['Content-Type'] = 'text/html; charset=UTF-8'
  res.body = Cowsay.say("Hello #{name} #{surname} #{age}", 'cow')
end
