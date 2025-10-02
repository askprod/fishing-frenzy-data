class Statistics::FetchItemsStatisticsJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Item.fetch_and_create_all_statistics

    [ Items::Fish, Items::Chest, Items::Rod ].each do |item_class|
      item_class.refresh_best_performer("floor_price")
    end
  end
end
