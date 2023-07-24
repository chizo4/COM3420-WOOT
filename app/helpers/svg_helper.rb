# frozen_string_literal: true

module SvgHelper
  def show_svg(path, options = {})
    file_path = "app/packs/images/#{path}"
    svg_tag(File.open(file_path, 'rb') { |file| raw file.read }, options)
  end

  def svg_tag(source, options = {})
    options = options.symbolize_keys
    options[:width], options[:height] = extract_dimensions(options.delete(:size)) if options[:size]
    "<svg #{tag_builder.tag_options(options) if options}>  #{source} </svg>".html_safe
  end
end
