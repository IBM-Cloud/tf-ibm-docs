# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
  config.cascade  = false
  config.inline   = true
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# Markdown
set :markdown_engine, :redcarpet
set :markdown,
    fenced_code_blocks: true,
    smartypants: true,
    prettify: true,
    tables: true,
    with_toc_data: true,
    no_intra_emphasis: true,
    autolink: true,
    lax_spacing: true

# Activate the syntax highlighter
activate :syntax

# Assets
set :css_dir, 'stylesheets'
set :js_dir, 'javascript'

# Build Configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :relative_assets
  # activate :asset_hash
  # activate :gzip
end
