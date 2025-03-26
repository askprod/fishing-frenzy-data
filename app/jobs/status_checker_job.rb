class StatusCheckerJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Utilities::StatusChecker.check_status
  end
end
