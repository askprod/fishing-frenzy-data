class UI::ItemCardComponent < ViewComponent::Base
  def initialize(**options)
    @image_path = options[:image_path] || ""
    @title = options[:title] || ""
    @labels = options[:labels] || []
    @left_footer = options[:right_footer] || ""
    @right_footer = options[:left_footer] || ""
  end
end
