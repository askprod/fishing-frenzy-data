class UI::ItemCardComponent < ViewComponent::Base
  def initialize(**options)
    @image_path = options[:image_path] || ""
    @title = options[:title] || ""
    @subtitle = options[:subtitle] || ""
    @description = options[:description] || ""
    @labels = options[:labels] || []
    @left_footer = options[:right_footer] || ""
    @right_footer = options[:left_footer] || ""
    @top_right_labels = options[:top_right_labels] || []
    @scale_image = options[:scale_image].nil? ? false : options[:scale_image]
    @image_classes = options[:image_classes] || ""
  end

  def scale_image?
    @scale_image
  end
end
