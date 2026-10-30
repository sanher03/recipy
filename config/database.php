<?php

function database_connection()
{
    if (!function_exists('pg_connect')) {
        throw new RuntimeException('The PHP pgsql extension is required.');
    }

    $envFile = dirname(__DIR__) . '/.env';
    if (is_file($envFile)) {
        $environment = parse_ini_file($envFile, false, INI_SCANNER_RAW);
        if ($environment === false) {
            throw new RuntimeException('Could not read the .env file.');
        }

        foreach ($environment as $key => $value) {
            if (is_string($value) && getenv($key) === false) {
                putenv($key . '=' . $value);
            }
        }
    }

    $environmentVariables = [
        'host' => 'DB_HOST',
        'port' => 'DB_PORT',
        'database' => 'DB_NAME',
        'user' => 'DB_USER',
        'password' => 'DB_PASSWORD',
    ];

    $config = [];
    foreach ($environmentVariables as $key => $environmentVariable) {
        $value = getenv($environmentVariable);
        if ($value !== false) {
            $config[$key] = $value;
        }
    }

    foreach (['host', 'database', 'user'] as $requiredKey) {
        if (!isset($config[$requiredKey]) || !is_scalar($config[$requiredKey]) || $config[$requiredKey] === '') {
            throw new RuntimeException(
                'Set DB_HOST, DB_NAME and DB_USER in .env or the process environment.'
            );
        }
    }

    $config['port'] = $config['port'] ?? 5432;
    $config['password'] = $config['password'] ?? '';

    $connectionString = '';
    foreach (['host', 'port', 'database', 'user', 'password'] as $key) {
        $value = str_replace(['\\', "'"], ['\\\\', "\\'"], (string) $config[$key]);
        $connectionKey = $key === 'database' ? 'dbname' : $key;
        $connectionString .= $connectionKey . "='" . $value . "' ";
    }

    $connection = pg_connect($connectionString);
    if ($connection === false) {
        error_log('PostgreSQL connection failed for database "' . $config['database'] . '".');
        throw new RuntimeException('PostgreSQL connection failed. Check database availability and credentials.');
    }

    return $connection;
}
