#!/usr/bin/env php
<?php

declare(strict_types=1);

$pluginDir = basename(dirname(__DIR__));

echo PHP_EOL;
echo "  \033[42;30m DONE \033[0m Your plugin is ready!" . PHP_EOL;
echo PHP_EOL;
echo "  \033[36mcd {$pluginDir}\033[0m" . PHP_EOL;
echo "  \033[36mgit init && git add -A && git commit -m 'Initial commit'\033[0m" . PHP_EOL;
echo "  \033[36msymfony serve -d\033[0m" . PHP_EOL;
echo PHP_EOL;

unlink(__FILE__);
