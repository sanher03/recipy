<?php
require_once __DIR__ . '/../config/database.php';
session_start();
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Invalid request method.']);
    exit;
}

$currentUsername = $_SESSION['username'] ?? null;
if (!is_string($currentUsername) || $currentUsername === '') {
    http_response_code(403);
    echo json_encode(['error' => 'You must be logged in to edit your profile.']);
    exit;
}

$newUsername = trim($_POST['username'] ?? '');
$email = trim($_POST['email'] ?? '');
$password = $_POST['password'] ?? '';

if ($newUsername === '' || $email === '') {
    http_response_code(400);
    echo json_encode(['error' => 'Username and email are required.']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['email' => 'Enter a valid email address.']);
    exit;
}

$dbconn = database_connection();

$usernameQuery = 'SELECT 1 FROM users WHERE username = $1 AND username <> $2';
$usernameResult = pg_query_params($dbconn, $usernameQuery, [$newUsername, $currentUsername]);
if ($usernameResult === false) {
    pg_close($dbconn);
    http_response_code(500);
    echo json_encode(['error' => 'Could not validate the username.']);
    exit;
}

if (pg_num_rows($usernameResult) > 0) {
    pg_close($dbconn);
    http_response_code(409);
    echo json_encode(['username' => 'This username is already in use.']);
    exit;
}

$emailQuery = 'SELECT 1 FROM users WHERE email = $1 AND username <> $2';
$emailResult = pg_query_params($dbconn, $emailQuery, [$email, $currentUsername]);
if ($emailResult === false) {
    pg_close($dbconn);
    http_response_code(500);
    echo json_encode(['error' => 'Could not validate the email address.']);
    exit;
}

if (pg_num_rows($emailResult) > 0) {
    pg_close($dbconn);
    http_response_code(409);
    echo json_encode(['email' => 'This email address is already in use.']);
    exit;
}

$userQuery = 'SELECT profile_pic FROM users WHERE username = $1';
$userResult = pg_query_params($dbconn, $userQuery, [$currentUsername]);
$user = $userResult === false ? false : pg_fetch_assoc($userResult);
if ($user === false || $user === null) {
    pg_close($dbconn);
    http_response_code(404);
    echo json_encode(['error' => 'The user profile could not be found.']);
    exit;
}

$profilePic = $user['profile_pic'];
$uploadedFilePath = null;
$uploadedFileUrl = null;

if (isset($_FILES['profileImage']) && $_FILES['profileImage']['error'] !== UPLOAD_ERR_NO_FILE) {
    $upload = $_FILES['profileImage'];
    if ($upload['error'] !== UPLOAD_ERR_OK) {
        pg_close($dbconn);
        http_response_code(400);
        echo json_encode(['error' => 'The profile image could not be uploaded. Please try again.']);
        exit;
    }

    $maxImageSize = 2 * 1024 * 1024;
    if ($upload['size'] <= 0 || $upload['size'] > $maxImageSize) {
        pg_close($dbconn);
        http_response_code(400);
        echo json_encode(['error' => 'The profile image must be smaller than 2 MB.']);
        exit;
    }

    $imageInfo = @getimagesize($upload['tmp_name']);
    $mimeToExtension = [
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        'image/gif' => 'gif',
        'image/webp' => 'webp',
    ];
    $imageMime = $imageInfo['mime'] ?? '';
    if ($imageInfo === false || !isset($mimeToExtension[$imageMime])) {
        pg_close($dbconn);
        http_response_code(400);
        echo json_encode(['error' => 'Choose a valid JPEG, PNG, GIF, or WebP image.']);
        exit;
    }

    $uploadDirectory = dirname(__DIR__) . '/img/profiles';
    if (!is_dir($uploadDirectory) && !mkdir($uploadDirectory, 0755, true) && !is_dir($uploadDirectory)) {
        pg_close($dbconn);
        http_response_code(500);
        echo json_encode(['error' => 'The profile image directory is not available.']);
        exit;
    }

    $fileName = 'profile_' . bin2hex(random_bytes(16)) . '.' . $mimeToExtension[$imageMime];
    $uploadedFilePath = $uploadDirectory . '/' . $fileName;
    $uploadedFileUrl = '../img/profiles/' . $fileName;
    if (!move_uploaded_file($upload['tmp_name'], $uploadedFilePath)) {
        pg_close($dbconn);
        http_response_code(500);
        echo json_encode(['error' => 'The profile image could not be saved. Check folder permissions.']);
        exit;
    }

    $profilePic = $uploadedFileUrl;
}

if ($password !== '') {
    $passwordHash = password_hash($password, PASSWORD_DEFAULT);
    $updateQuery = 'UPDATE users
                    SET username = $1, email = $2, profile_pic = $3, password = $4
                    WHERE username = $5';
    $params = [$newUsername, $email, $profilePic, $passwordHash, $currentUsername];
} else {
    $updateQuery = 'UPDATE users
                    SET username = $1, email = $2, profile_pic = $3
                    WHERE username = $4';
    $params = [$newUsername, $email, $profilePic, $currentUsername];
}

$updated = pg_query_params($dbconn, $updateQuery, $params);
if ($updated === false) {
    if ($uploadedFilePath !== null) {
        unlink($uploadedFilePath);
    }
    pg_close($dbconn);
    http_response_code(500);
    echo json_encode(['error' => 'Your profile could not be updated. Please try again.']);
    exit;
}

$_SESSION['username'] = $newUsername;
pg_close($dbconn);

echo json_encode([
    'success' => true,
    'username' => $newUsername,
    'email' => $email,
    'profilePic' => $profilePic,
]);
