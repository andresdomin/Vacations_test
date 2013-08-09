set :output, "#{path}/log/cron.log"

every 1.day, :at => '11:57pm' do
  runner 'Request.send_today_requests'
end
