class RefreshApiTokensJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Utilities::RefreshApiTokens.call
  end
end
