class SprocketsController < ActionController::Base
  caches_page :show, :if => Proc.new { SprocketsApplication.use_page_caching }
  
  def show
    source = SprocketsApplication.source_for_build(params[:id])
    render :text => source, :content_type => "text/javascript"
  end
end
