maintainer        "Motiejus Jakštys"
maintainer_email  "desired.mta@gmail.com"
license           "Apache 2.0"
description       "Installs/Configures drbd."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.9.1"

%w{ debian ubuntu }.each do |os|
  supports os
end
