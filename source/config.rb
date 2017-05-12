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

# Assets
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
# @ckelner: we don't activate this in support of having "/docs/assets" pulled from remotes
#set :images_dir, 'images'
set :fonts_dir, 'fonts'

# Activate the syntax highlighter
activate :syntax

activate :autoprefixer do |config|
  config.browsers = ['last 2 version', 'Firefox ESR']
  config.cascade  = false
  config.inline   = true
end

# ~~Github pages require relative links~~ (strikethrough)
# @ckelner: we don't activate this in support of having "/docs/assets" pulled from remotes
#activate :relative_assets
#set :relative_links, true

# Build Configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :relative_assets
  # activate :asset_hash
  # activate :gzip
end
