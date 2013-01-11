namespace :font do
  
  desc "Generate font(s) from app/assets/svg/*.svg"
  task :build => :environment do
    Font.build
  end
end
