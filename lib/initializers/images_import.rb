class Initializers::ImagesImport
  IMAGES_FOLDER = Rails.root.join("public", "images")
  attr_reader :folder_name, :images_dir, :folder, :json, :data, :mesh, :original_image

  def initialize(folder_name)
    @folder_name = folder_name
    @images_dir = "#{IMAGES_FOLDER}/#{@folder_name}"
    @folder = Rails.root.join("lib", "meshes", @folder_name)
    @json = JSON.parse(File.read("#{@folder}/data.json"))
    @original_image = ChunkyPNG::Image.from_file("#{@folder}/mesh.png")

    # For now, lets hope the @data is stored in the same way in each file
    # drop(1) as the first value always seems to not be related
    # EDIT: This actually seems to work most of the time after testing (!!)
    @data = @json[5].drop(1)
  end

  def self.extract(folder_name)
    klass = self.new(folder_name)
    klass.extract
  end

  def extract
    @data.each do |mesh_data|
      nested_data = mesh_data.dig(0, 0)
      name = nested_data.dig("name")
      rect = nested_data.dig("rect")
      original_size = nested_data.dig("originalSize")
      rotated = nested_data.dig("rotated")
      create_file(name, rect, original_size, rotated)
    end
  end

  private

  def create_file(file_name, position, size, rotated)
    return if image_already_exists?(file_name)

    image_x = position.dig("x")
    image_y = position.dig("y")
    rect_width = position.dig("width")
    rect_height = position.dig("height")
    cropped_image = ChunkyPNG::Image.new(rect_width, rect_height)
    cropped_image = @original_image.crop(image_x, image_y, (rotated ? rect_height : rect_width), (rotated ? rect_width : rect_height))
    cropped_image = cropped_image.rotate_left if rotated

    create_images_dir unless images_dir_exists?
    cropped_image.save("#{@images_dir}/#{file_name}.png");nil
  end

  def create_images_dir
    Dir.mkdir(@images_dir) unless images_dir_exists?
  end

  def images_dir_exists?
    Dir.exist?(@images_dir)
  end

  def image_already_exists?(image_name)
    return false unless images_dir_exists?
    Dir.entries(@images_dir).include?(image_name)
  end
end
