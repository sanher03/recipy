<?php
require_once __DIR__ . '/../config/database.php';
    session_start();

    if (!isset($_SESSION['username'])) {
        http_response_code(403);
        echo "Access denied. Please log in.";
        exit;
    }
    
    $username = $_SESSION['username'];
    
    if (!isset($_SESSION['exploring_recipe_id'])) {
        echo "No recipe is selected.";
        exit;
    }
    
    $recipe_id=$_SESSION['exploring_recipe_id'];

    $conn = database_connection();

    if (!$conn) {
        http_response_code(500);
        echo json_encode(['error' => 'Error al conectar con la base de datos']);
        exit;
    }

    $query = "SELECT * FROM comments WHERE recipe_id = $1;";
    $result1 = pg_query_params($conn, $query, [$recipe_id]);

    $comments = [];
    
    while ($row = pg_fetch_assoc($result1)) {
        $comments[] = $row;
    }
    
    echo json_encode($comments);
    
    pg_close($conn);
?>