class Font
  
  # This helper is a stand-in until one of these problems is fixed:
  # 
  # 1. fontcustom supports ligatures
  # 2. webkit supports CSS transitions on :before elements
  def self.render(word)
    return "?" unless Font.characters.include?(word.to_s)
    "&#xf#{100 + Font.characters.index(word.to_s)}".html_safe
  end
  
  def self.characters
    @characters ||= JSON.parse(File.read(Rails.root.join("config/font.json")))
  rescue LoadError
    puts "config/font.json doesn't exist. Run rake font:build"
    exit
  end
  
  def self.build
    font_name = "miyagi"
    input_dir = Rails.root.join("app/assets/svg")
    output_dir = Rails.root.join("app/assets/fonts")

    # Generate the new font
    system "fontcustom compile #{input_dir} --output=#{output_dir} --name=#{font_name} --nohash"
  
    # Remove unneeded generated files
    system "rm #{output_dir}/fontcustom.css"
    system "rm #{output_dir}/#{font_name}.eot"
    system "rm #{output_dir}/#{font_name}.svg"
    system "rm #{output_dir}/#{font_name}.ttf"

    # Collect all character names from SVG filenames
    # characters = Dir.entries(input_dir).select{|f| f.ends_with?('svg') }.map{|f| f.sub('.svg', '') }.sort
    Dir["#{input_dir}/*.svg"].map{|f| File.basename(f, ".svg") }.sort
  
    puts "create config/font.json for characters: #{characters.join(', ')}."

    File.open(Rails.root.join("config/font.json"), "w") do |file|
      file.write characters.to_json
    end    

  end
  
end