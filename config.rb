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
  files = Dir.glob("source/tabs/#{directory}/*.gp5")
  files.each do |file|
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
