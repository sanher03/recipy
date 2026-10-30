<?php
require_once __DIR__ . '/../config/database.php';
session_start();

if (!isset($_SESSION['username'])) {
    http_response_code(403);
    echo json_encode(['error' => 'Access denied. Please log in.']);
    exit;
}

$username = $_SESSION['username'];

$code = filter_input(INPUT_GET, 'code', FILTER_VALIDATE_INT);
$recipe_id = filter_input(INPUT_GET, 'recipe_id', FILTER_VALIDATE_INT);

if (!in_array($code, [0, 1], true) || $recipe_id === false || $recipe_id === null || $recipe_id < 1) {
    http_response_code(400);
    echo json_encode(['error' => 'A valid action and recipe ID are required.']);
    exit;
}

$conn = database_connection();
if ($code === 0) {
    $query = "DELETE FROM saved_recipes WHERE username = $1 AND recipe_id = $2;";
    $result = pg_query_params($conn, $query, [$username, $recipe_id]);
} else {
    $query = "INSERT INTO saved_recipes (username, recipe_id) VALUES ($1, $2)
              ON CONFLICT (username, recipe_id) DO NOTHING;";
    $result = pg_query_params($conn, $query, [$username, $recipe_id]);
}

if ($result === false) {
    http_response_code(500);
    echo json_encode(['error' => 'Could not update the saved recipe.']);
} else {
    header('Content-Type: application/json');
    echo json_encode(true);
}
pg_close($conn);
?>
