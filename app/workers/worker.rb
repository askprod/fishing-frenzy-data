require "rufus-scheduler"

scheduler = Rufus::Scheduler.new

scheduler.every "1m" do
  StatusCheckerJob.perform_later
end

scheduler.join
