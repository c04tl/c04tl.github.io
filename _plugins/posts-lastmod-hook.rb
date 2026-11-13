require "date"
require "time"
require "open3"
require "nokogiri"
require "pathname"

module BlogContent
  module_function

  def git_update(post)
    return unless File.exist?(File.join(post.site.source, ".git"))
    path = Pathname.new(File.expand_path(post.path, post.site.source)).relative_path_from(Pathname.new(post.site.source)).to_s
    commits, status = Open3.capture2("git", "-C", post.site.source, "log", "-2", "--format=%aI", "--", path)
    commits.lines.first if status.success? && commits.lines.size > 1
  rescue Errno::ENOENT
    nil
  end

  def prepare_post(post)
    html = post.site.find_converter_instance(Jekyll::Converters::Markdown).convert(post.content)
    fragment = Nokogiri::HTML.fragment(html)
    summary = post.data["description"].to_s.strip
    summary = fragment.at_css("p")&.text.to_s if summary.empty?
    post.data["card_summary"] = summary.gsub(/[[:space:]]+/, " ").strip
    if post.data["card_summary"].length > 155
      post.data["card_summary"] = post.data["card_summary"][0, 155].sub(/\s+\S*\z/, "") + "…"
    end

    image = post.data["image"]
    image = image["path"] if image.is_a?(Hash)
    if image.to_s.empty?
      image = fragment.css("img").map { |img| img["src"] }.find do |src|
        src && src.match?(%r{\A/assets/[\w./%-]+\z}) &&
          !src.split("/").include?("..") && File.file?(File.join(post.site.source, src.delete_prefix("/")))
      end
    end
    post.data["card_image"] = image.to_s.empty? ? "/assets/img/cover-default.svg" : image

    post.data["outline"] = fragment.css("h1[id], h2[id], h3[id]").map do |heading|
      { "id" => heading["id"], "title" => heading.text.strip }
    end
    fragment.css("pre, script, style").remove
    count = fragment.text.scan(/[[:alnum:]]+(?:[-’'][[:alnum:]]+)*/).size
    post.data["reading_minutes"] = [(count / 200.0).ceil, 1].max

    updated = post.data["last_modified_at"] || git_update(post)
    return unless updated
    value = Time.parse(updated.to_s)
    if value > post.date
      post.data["updated_on"] = value.getlocal(post.date.utc_offset)
      post.data["last_modified_at"] = value
    end
  rescue ArgumentError => error
    raise Jekyll::Errors::FatalException, "#{post.relative_path}: #{error.message}"
  end

  def prepare_resource(site, resource)
    data = resource.data
    fail_resource = ->(message) { raise Jekyll::Errors::FatalException, "#{resource.relative_path}: #{message}" }
    %w[title description tipo archivo].each do |key|
      fail_resource.call("falta #{key}") unless data[key].is_a?(String) && !data[key].strip.empty?
    end
    url = data["archivo"]
    unless url.match?(%r{\A/assets/recursos/(?:[a-zA-Z0-9_-]+/)*[a-zA-Z0-9_-]+(?:\.[a-zA-Z0-9_-]+)*\.[a-zA-Z0-9]+\z})
      fail_resource.call("archivo debe apuntar a /assets/recursos/ con nombres sin espacios")
    end
    file = File.join(site.source, url.delete_prefix("/"))
    root = File.join(site.source, "assets", "recursos")
    unless File.file?(file) && File.realpath(file).start_with?(File.realpath(root) + File::SEPARATOR) &&
        File.realpath(root).start_with?(File.realpath(site.source) + File::SEPARATOR)
      fail_resource.call("no se encontró un archivo local válido en #{url}")
    end
    bytes = File.size(file)
    data["file_format"] = File.extname(file).delete_prefix(".").upcase
    data["file_size"] = if bytes >= 1024 * 1024
                          "#{format('%.1f', bytes / 1024.0 / 1024).tr('.', ',')} MB"
                        elsif bytes >= 1024
                          "#{(bytes / 1024.0).ceil} KB"
                        else
                          "#{bytes} B"
                        end
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  site.posts.docs.each { |post| BlogContent.prepare_post(post) }
  site.collections.fetch("recursos").docs.each { |resource| BlogContent.prepare_resource(site, resource) }
end
