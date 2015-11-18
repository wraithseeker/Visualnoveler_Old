
# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.visualnoveler.com"

SitemapGenerator::Sitemap.create do

  add '/pages'
  Vn.find_each do |vn|
    add vn_path(vn), lastmod: vn.updated_at
  end

  User.find_each do |user|
    add user_path(user), lastmod: user.updated_at
    add watch_user_path(user), lastmod: user.updated_at
    add favourite_user_path(user), lastmod: user.updated_at
   # add drop_path(user), lastmod: user.updated_at
   # add wishlist_path(user), lastmod: user.updated_at
  end

  Genre.find_each do |genre|
    add genre_path(genre), lastmod: genre.updated_at
  end

  add genres_path
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end