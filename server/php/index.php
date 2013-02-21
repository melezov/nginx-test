<?php
  define('SECURE', isset($_SERVER['HTTP_X_FORWARDED_PROTO']) &&
                         $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https');
?>

<h1>It is I, Doctore!</h1>

<img width="123" src="/static/server-orange.png">
<?php if (SECURE):?><img src="/static/secure.png"><?php endif; ?>
<br><br><hr>

<ul>
<?php
foreach($_SERVER as $k => $v) {
  if (strpos($k, 'HTTP') === 0)
    echo '<li>'
       , htmlspecialchars($k), ' => <b>'
       , htmlspecialchars($v), '</b>'
       , '</li>';
}

if (SECURE):?>
<a href="http://nginx-test.com/">Go to peasant mode</a>
<?php else:?>
<a href="https://auth.nginx-test.com/">Go to <b>AUTHORITA</b> mode</a>
<?php endif;?>
