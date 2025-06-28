class Records::RefreshCookingRecordsJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Cooking::Recipe.update_all(available: false)
    Initializers::CookingModelsInitializer.call(should_create_records: true)
  end
end
