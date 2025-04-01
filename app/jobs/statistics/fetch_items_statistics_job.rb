class Statistics::FetchItemsStatisticsJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Item.fetch_and_create_all_statistics
  end
end
