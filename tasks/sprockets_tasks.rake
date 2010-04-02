namespace :sprockets do
  desc "Generate and install the Sprockets concatenated JavaScript files"
  task :install_scripts => :environment do
    SprocketsApplication.install_scripts
  end
  
  desc "Install any assets provided by Sprockets scripts"
  task :install_assets => :environment do
    SprocketsApplication.install_assets
  end
end