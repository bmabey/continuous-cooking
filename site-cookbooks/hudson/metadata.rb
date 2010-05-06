maintainer       "Ben Mabey"
maintainer_email "ben@benmabey.com"
license          "Apache 2.0"
description      "Installs/Configures hudson"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

%w[apt nginx].each do |cb|
  depends cb
end
