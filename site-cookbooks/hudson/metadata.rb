maintainer       "Ben Mabey"
maintainer_email "ben@benmabey.com"
license          "MIT"
description      "Installs/Configures hudson"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

%w[apt nginx rvm].each do |cb|
  depends cb
end
supports "ubuntu"
