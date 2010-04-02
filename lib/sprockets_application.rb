module SprocketsApplication
  mattr_accessor :use_page_caching
  self.use_page_caching = true
  
  BUILDS = {}
  
  class << self
    def routes(map)
      map.resources(:sprockets)
    end
    
    def configuration
      YAML.load(IO.read(File.join(RAILS_ROOT, "config", "sprockets.yml"))) || {}
    end
    
    def source_for_build(name = :default)
      build(name).source
    end
    
    def install_scripts
      each_build { |b| b.install_script }
    end
    
    def install_assets
      each_build { |b| b.install_assets }
    end
    
    protected
      def each_build
        configuration[:builds].keys.each do |name|
          yield build(name)
        end
      end
      
      def build(name)
        name = name.to_sym
        BUILDS[name] ||= Build.new(name)
      end
  end
  
  class Build
    attr_reader :name
    
    def initialize(name)
      @name = name
    end
    
    def source
      concatenation.to_s
    end
    
    def install_script
      concatenation.save_to(asset_path)
    end
    
    def install_assets
      secretary.install_assets
    end
    
    protected
      def secretary
        @secretary ||= Sprockets::Secretary.new(configuration)
      end
      
      def configuration
        SprocketsApplication.configuration.except(:builds).merge(
          :source_files => source_files,
          :root => Rails.root
        )
      end
      
      def source_files
        SprocketsApplication.configuration[:builds][name]
      end
    
      def concatenation
        secretary.reset! unless source_is_unchanged?
        secretary.concatenation
      end
      
      def asset_path
        File.join(Rails.public_path, "#{name}.js")
      end
      
      def source_is_unchanged?
        previous_source_last_modified, @source_last_modified = 
          @source_last_modified, secretary.source_last_modified
        
        previous_source_last_modified == @source_last_modified
      end
  end
end
