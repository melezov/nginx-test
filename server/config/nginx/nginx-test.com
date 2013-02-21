upstream www-bucket  {
  server remote-nginx-test-runner:10000;
  server local-nginx-test-runner:10000 backup;
} 

server {
  listen nginx-test.com:80;
  server_name .nginx-test.com;

  location ~ ^(/static/.+)$ {
    root       /var/www/ZgPhp;
    expires    30d;
  }
  
  location / {
    proxy_pass http://www-bucket;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }

  access_log /var/www/ZgPhp/server/logs/nginx/www-access.log;
  error_log  /var/www/ZgPhp/server/logs/nginx/www-error.log;
}

server {
  listen nginx-test.com:443;
  server_name .nginx-test.com;

  ssl on;
  ssl_certificate     /var/www/ZgPhp/server/config/certs/server/wc.nginx-test.com.pem;
  ssl_certificate_key /var/www/ZgPhp/server/config/certs/server/wc.nginx-test.com.key;

  rewrite (.*) http://nginx-test.com$1 redirect;

  access_log /var/www/ZgPhp/server/logs/nginx/www-access.log;
  error_log  /var/www/ZgPhp/server/logs/nginx/www-error.log;
}
