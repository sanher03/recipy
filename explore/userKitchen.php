<?php
require_once __DIR__ . '/../config/database.php';
  session_start();
  $username = $_SESSION['username'] ?? null;

  $active_user="";

if (isset($_GET['user']) && is_string($_GET['user'])) {
    $active_user = $_GET['user'];
  }
  $dbconn = database_connection();
$q0 = "SELECT * FROM users WHERE username = $1";
  $result = pg_query_params($dbconn, $q0, array($active_user));

if (!$result || !($tuple = pg_fetch_array($result, null, PGSQL_ASSOC))) {
    pg_close($dbconn);
    http_response_code(404);
    exit('<h1>User not found</h1>');
}

$name=$tuple['name'];
$profile_pic=$tuple['profile_pic'];
$escape = static fn($value) => htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');

$q0 = "SELECT 
    r.*, 
    COUNT(s_all.recipe_id) AS times_saved,
    COUNT(s_user.recipe_id) > 0 AS is_saved
  FROM recipes r
  LEFT JOIN saved_recipes s_all ON r.id = s_all.recipe_id
  LEFT JOIN saved_recipes s_user ON r.id = s_user.recipe_id AND s_user.username = $2
  WHERE r.author = $1
  GROUP BY r.id;
";
$result = pg_query_params($dbconn, $q0, [$active_user, $username]);
if ($result === false) {
  error_log('User kitchen recipe query failed: ' . pg_last_error($dbconn));
  pg_close($dbconn);
  http_response_code(500);
  exit('<h1>Could not load this user kitchen</h1>');
}
pg_close($dbconn);

  if (pg_num_rows($result) === 0) {
    echo "<h1>No recipes found</h1>";
}
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>UserKitchen - Recipy</title>
    <link rel="stylesheet" href="../css/styles.css" />
    <link rel="stylesheet" href="../css/explore.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
    />
    <script src="../js/explore.js"></script>
    <script src="https://unpkg.com/vue@3"></script>
  </head>
  <body>
    <?php include '../components/header.php'; ?>

    <div class="user-kitchen-container">
      <div class="user-kitchen-header">
        <div class="user-kitchen-info">
          <img
            src="<?php echo $escape($profile_pic); ?>"
            alt="User Avatar"
            class="user-kitchen-avatar"
          />
          <h1><?php echo $escape($name); ?>’s Kitchen</h1>
        </div>
      </div>
    </div>

    <section class="explore-section">
      <?php
        include '../components/carousel-section.php';
      ?>
    </section>

    <?php include '../components/footer.php'; ?>
  </body>
</html>
