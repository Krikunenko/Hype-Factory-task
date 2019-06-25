<?php

define('HOST', '');
define('PORT', '');
define('DB_NAME', '');
define('USER', '');
define('PASSWORD', '');

try {
    $pdo = new PDO('mysql:host=' . HOST . ';port=' . PORT . ';dbname=' . DB_NAME, USER, PASSWORD);
    $statement = $pdo->prepare('SELECT email FROM users LIMIT 500 OFFSET ?');

    $domainCounter = [];

    $i = 0;

    do {
        $statement->execute([$i * 500]);
        $result = $statement->fetchAll();

        foreach ($result as $row) {
            $emails = array_map('trim', explode(',', $row['email']));
            $domains = array_map(function ($email) {
                return substr($email, strpos($email, '@') + 1);
            }, $emails);
            foreach ($domains as $domain => $count) {
                if (isset($domainCounter[$domain])) {
                    $domainCounter[$domain] += $count;
                } else {
                    $domainCounter[$domain] = $count;
                }
            }
        }

        $i++;
    } while (count($result) > 0);

    foreach ($domainCounter as $domain => $counter) {
        echo "{$domain}: {$counter}" . PHP_EOL;
    }
} catch (Exception $e) {
    die($e->getMessage());
}