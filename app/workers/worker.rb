require "rufus-scheduler"

scheduler = Rufus::Scheduler.new

scheduler.every "1m" do
  system("rails runner StatusCheckerJob.perform_later")
end

scheduler.join
