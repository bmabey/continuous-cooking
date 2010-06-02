maintainer        "Ben Mabey"
maintainer_email  "ben@benmabey.com"
license           "MIT"
description       "Installs and configures gerrit"
version           "0.1"
recommends        "nginx"

%w{ ubuntu debian }.each do |os|
  supports os
end

%w{ java postfix}.each do |cb|
  depends cb
end
