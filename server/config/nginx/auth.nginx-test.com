upstream auth-bucket  {
  server remote-nginx-test-runner:10000;
  server local-nginx-test-runner:10000 backup;
}

server {
  listen auth.nginx-test.com:80;
  server_name .nginx-test.com;

  rewrite (.*) https://auth.nginx-test.com$1 redirect;

  access_log /var/www/ZgPhp/server/logs/nginx/auth-access.log;
  error_log  /var/www/ZgPhp/server/logs/nginx/auth-error.log;
}

server {
  listen auth.nginx-test.com:443;
  server_name .nginx-test.com;

  ssl on;
  ssl_certificate     /var/www/ZgPhp/server/config/certs/server/wc.nginx-test.com.pem;
  ssl_certificate_key /var/www/ZgPhp/server/config/certs/server/wc.nginx-test.com.key;

  # ssl_client_certificate /var/www/ZgPhp/server/config/certs/client/marko@auth.nginx-test.com.pem;
  # ssl_verify_client optional;

  location ~ ^(/static/.+)$ {
    root       /var/www/ZgPhp;
    expires    30d;
  }

  location / {
    proxy_pass http://auth-bucket;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Client-Verify $ssl_client_verify;
    proxy_set_header X-Client-DN $ssl_client_s_dn;
  }

  access_log /var/www/ZgPhp/server/logs/nginx/auth-access.log;
  error_log  /var/www/ZgPhp/server/logs/nginx/auth-error.log;
}
