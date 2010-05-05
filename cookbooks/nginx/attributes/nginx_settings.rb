nginx Mash.new unless attribute? "nginx"

nginx[:gzip] = Mash.new unless nginx.has_key?(:gzip)
nginx[:gzip][:http_version] = "1.0"
nginx[:gzip][:comp_level] = "2"
nginx[:gzip][:proxied] = "any"
nginx[:gzip][:types] = [ "text/plain",
                          "text/html",
                          "text/css",
                          "application/x-javascript",
                          "text/xml",
                          "application/xml",
                          "application/xml+rss",
                          "text/javascript" ]
                          
nginx[:keepalive] = Mash.new unless nginx.has_key?(:keepalive)
nginx[:keepalive][:timeout] = 65 unless nginx[:keepalive].has_key?(:timeout)

nginx[:worker] = Mash.new unless nginx.has_key?(:worker)
nginx[:worker][:processes] = 6 unless nginx[:worker].has_key?(:processes)
nginx[:worker][:connections] = 1024 unless nginx[:worker].has_key?(:connections)

nginx[:server_names_hash_bucket_size] = 64 unless nginx.has_key?(:server_names_hash_bucket_size)
