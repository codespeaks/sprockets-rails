module SprocketsHelper
  def sprockets_include_tag(build = :default)
    javascript_include_tag(sprocket_path(build, :format => :js))
  end
end
