class StatusCheckerJob < ApplicationJob
  queue_as :solid_queue

  def perform(forced_status: nil)
    Utilities::StatusChecker.check_status(forced_status: forced_status)
  end
end
