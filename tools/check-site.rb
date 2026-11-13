require "nokogiri"
require "open3"
require "uri"

ROOT = File.expand_path("../_site", __dir__)
NAVIGATION = ["/", "/recursos/", "/archives/", "/about/"].freeze

def document(path)
  Nokogiri::HTML(File.read(File.join(ROOT, path), encoding: "UTF-8"))
end

def assert(condition, message)
  abort message unless condition
end

def local_file(url)
  path = URI::DEFAULT_PARSER.unescape(url.split(/[?#]/, 2).first)
  path += "index.html" if path.end_with?("/")
  File.file?(File.join(ROOT, path.delete_prefix("/")))
end

home = document("index.html")
assert(home.css("nav[aria-label='Menú principal'] a").map { |a| a["href"] } == NAVIGATION, "Menú inesperado")
cards = home.css("article[data-entry]")
assert(!cards.empty?, "La portada no muestra artículos")
cards.each do |card|
  assert(card.at_css("img") && card.at_css("h2 a") && card.at_css(".card-body p") &&
    card.at_css("time") && card.at_css(".meta").text.include?("min de lectura"), "Tarjeta de artículo incompleta")
  link = card.at_css("h2 a")["href"]
  assert(local_file(link), "Entrada inexistente: #{link}")
  assert(local_file(card.at_css("img")["src"]), "Imagen de tarjeta inexistente") if card.at_css("img")["src"].start_with?("/")
  post = document(link.delete_prefix("/") + "index.html")
  assert(post.at_css(".post-head h1") && post.at_css(".post-head time"), "Encabezado incompleto: #{link}")
  post.css(".post-head .tags a").each { |tag| assert(local_file(tag["href"]), "Etiqueta inexistente: #{tag['href']}") }
  post.css(".toc a").each do |anchor|
    id = URI::DEFAULT_PARSER.unescape(anchor["href"].delete_prefix("#"))
    assert(post.css("[id]").any? { |element| element["id"] == id }, "Ancla inexistente: #{link}##{id}")
  end
end

resources = document("recursos/index.html")
assert(resources.at_css("input[data-search]"), "Falta el buscador de recursos")
resources.css("article[data-entry]").each do |card|
  actions = card.css("a")
  assert(actions.size == 1 && actions.first.key?("download"), "Cada recurso debe tener una sola descarga")
  assert(local_file(actions.first["href"]), "Descarga inexistente: #{actions.first['href']}")
end

baseline, status = Open3.capture2("git", "ls-tree", "-r", "--name-only", "origin/gh-pages")
if status.success?
  legacy = baseline.lines.map(&:strip).grep(%r{\A(?:posts|categories|tags|archives|about)/.*index\.html\z})
  missing = legacy.reject { |path| File.file?(File.join(ROOT, path)) }
  assert(missing.empty?, "Rutas anteriores que faltan: #{missing.join(', ')}")
end
puts "Verificación correcta: #{cards.size} artículos, #{resources.css('article[data-entry]').size} recursos."
