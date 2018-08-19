# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

Dir.foreach('source/tabs') do |directory|
  next if ['.', '..'].include?(directory)
  all_files = Dir.glob("source/tabs/#{directory}/*.gp5")
  all_files.each do |file|
    title = file.gsub(/^.*\/(.+)\.gp5$/, '\1')
    author = directory
    file_path = "/tabs/#{author}/#{title}.gp5"
    proxy(
      "/player/#{title}.html",
      "/player/template.html",
      locals: {
        title: title,
        author: author,
        file_path: file_path,
      },
      ignore: true
    )
  end
end

list_items = Dir.entries('source/tabs').select { |d| !['.', '..'].include?(d) }.map { |d| { author: d, titles: Dir.glob("source/tabs/#{d}/*.gp5").map { |f| f.gsub(/^.*\/(.+)\.gp5$/, '\1') } } }.select { | r| r[:titles].size >0 }

proxy(
  "index.html",
  "template.html",
  locals: {
    list_items: list_items
  },
  ignore: true
)

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
  activate :directory_indexes
end
