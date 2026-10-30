<?php

if (PHP_SAPI !== 'cli') {
    http_response_code(404);
    exit;
}

require_once __DIR__ . '/../config/database.php';

$connection = database_connection();
pg_close($connection);

$dumpPath = __DIR__ . '/../database/dumps/recipy_seed.sql';
if (!is_file($dumpPath) || !is_readable($dumpPath)) {
    fwrite(STDERR, "Could not read database/dumps/recipy_seed.sql.\n");
    exit(1);
}

$command = [
    'psql',
    '--no-psqlrc',
    '--no-password',
    '--set=ON_ERROR_STOP=1',
    '--single-transaction',
    '--host=' . getenv('DB_HOST'),
    '--port=' . (getenv('DB_PORT') !== false ? getenv('DB_PORT') : '5432'),
    '--username=' . getenv('DB_USER'),
    '--dbname=' . getenv('DB_NAME'),
    '--file=' . $dumpPath,
];

$environment = getenv();
$environment['PGPASSWORD'] = getenv('DB_PASSWORD') ?: '';

$descriptors = [
    0 => ['file', '/dev/null', 'r'],
    1 => ['file', 'php://stdout', 'w'],
    2 => ['file', 'php://stderr', 'w'],
];
$process = proc_open($command, $descriptors, $pipes, null, $environment);

if (!is_resource($process)) {
    fwrite(STDERR, "Could not start psql. Install the PostgreSQL client tools.\n");
    exit(1);
}

$exitCode = proc_close($process);
if ($exitCode !== 0) {
    fwrite(STDERR, "Database dump import failed; psql exited with code {$exitCode}.\n");
    exit($exitCode);
}

fwrite(STDOUT, "Database dump imported successfully.\n");
