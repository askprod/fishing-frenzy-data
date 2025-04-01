class Statistics::FetchCollectionsStatisticsJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Collection.fetch_and_create_all_statistics
  end
end
