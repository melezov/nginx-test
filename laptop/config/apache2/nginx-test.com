Listen 10000

<VirtualHost local-nginx-test-runner:10000>
  Alias /static D:/ZgPhp/static
  <Directory D:/ZgPhp/static>
    AllowOverride none
    RewriteEngine on
    RewriteBase /static
    RewriteCond %{REQUEST_FILENAME} -f
    RewriteRule .* - [L]
  </Directory> 

  DocumentRoot D:/ZgPhp/laptop/php
  <Directory D:/ZgPhp/laptop/php>
    AllowOverride none
    RewriteEngine on
    RewriteBase /
    RewriteRule .* index.php
  </Directory>
  
  CustomLog "D:/ZgPhp/laptop/logs/apache2/www-access.log" combined
  ErrorLog "D:/ZgPhp/laptop/logs/apache2/www-error.log"
</VirtualHost>
