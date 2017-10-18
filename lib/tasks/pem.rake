namespace :pem do
  desc 'Generate a OpenSSL pem file'
  task create: :environment do
    if Dir["#{Rails.root}/*.pem"].empty?
      system 'openssl rsa -pubout -in private.pem -out public.pem'
    end
  end

  desc 'Remove generated .pem files'
  task remove: :environment do
    system "rm -f #{Rails.root}/*.pem"
  end
end
