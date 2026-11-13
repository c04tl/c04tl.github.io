require "fileutils"
require "jekyll"
require "nokogiri"
require "tmpdir"

root = File.expand_path("..", __dir__)
Dir.mktmpdir("c04tl-resource-") do |directory|
  source = File.join(directory, "source")
  FileUtils.mkdir_p(source)
  %w[_config.yml _plugins _layouts _includes _data _sass assets recursos.html].each do |name|
    FileUtils.cp_r(File.join(root, name), source)
  end
  FileUtils.mkdir_p(File.join(source, "_recursos"))
  FileUtils.mkdir_p(File.join(source, "assets", "recursos"))
  FileUtils.cp(File.join(__dir__, "fixtures", "cheatsheet.md"), File.join(source, "_recursos"))
  destination = File.join(directory, "site")
  config = -> { Jekyll.configuration("source" => source, "destination" => destination) }

  begin
    Jekyll::Site.new(config.call).process
    abort "La compilación aceptó una descarga inexistente"
  rescue Jekyll::Errors::FatalException => error
    raise unless error.message.include?("no se encontró un archivo local válido")
  end

  FileUtils.cp(File.join(__dir__, "fixtures", "comandos.txt"), File.join(source, "assets", "recursos"))
  Jekyll::Site.new(config.call).process
  html = Nokogiri::HTML(File.read(File.join(destination, "recursos", "index.html"), encoding: "UTF-8"))
  actions = html.css("[data-entry] a")
  unless actions.size == 1 && actions.first.key?("download") && actions.first["href"] == "/assets/recursos/comandos.txt" &&
      File.file?(File.join(destination, "assets", "recursos", "comandos.txt"))
    abort "El catálogo no generó una descarga válida"
  end
  puts "Ficha Markdown, descarga y validación de adjunto verificadas."
end
