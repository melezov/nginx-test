Listen 10000

<VirtualHost local-nginx-test-runner:10000>
  DocumentRoot /var/www/ZgPhp/server/php
  <Directory /var/www/ZgPhp/server/php>
    AllowOverride none
    RewriteEngine on
    RewriteBase /
    RewriteRule .* index.php
  </Directory>

  CustomLog "/var/www/ZgPhp/server/logs/apache2/www-access.log" combined
  ErrorLog "/var/www/ZgPhp/server/logs/apache2/www-error.log"
</VirtualHost>
