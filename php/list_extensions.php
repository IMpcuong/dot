<?php

echo 'PHP version: ' . phpversion();
$exts = get_loaded_extensions();
foreach($exts as $e) {
  $ext = new ReflectionExtension($e);
  $version = $ext->getVersion();
  echo "$e - $version" . PHP_EOL;
}
