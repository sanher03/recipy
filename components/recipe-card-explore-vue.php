<?php
  $likes = $recipe['times_saved'];

  $isSaved = $recipe['is_saved'] == 't';
?>

<div id="recipe-<?php echo $recipe['id'] ?>" class="recipe-card">
  <img src="<?php echo htmlspecialchars($recipe['image']) ?>" alt="Recipe" />
  <div class="recipe-info">
    <a class="recipe-title" href="../recipe/recipe.php?recipe_id=<?php echo $recipe['id'] ?>">
      <?php echo htmlspecialchars($recipe['title']) ?>
    </a>
    <span class="recipe-user">
      <a href="../explore/userKitchen.php?user=<?php echo $recipe['author'] ?>">@<?php echo htmlspecialchars($recipe['author']) ?></a>
      <span class="diners-count"> • <?php echo $recipe['diners'] ?> diners • {{ likes }} likes</span>
    </span>
    <button class="like-btn" :class="{ liked: liked }" @click="toggleLike">
      <i :class="[liked ? 'fa-solid' : 'fa-regular', 'fa-heart']"></i>
    </button>
  </div>
</div>
<script>
  Vue.createApp({
    data() {
      return {
        likes: <?php echo $likes ?>,
        liked: <?php echo json_encode($isSaved) ?>
      };
    },
    methods: {
      toggleLike() {
        const liked = !this.liked;
        const previousLiked = this.liked;
        const previousLikes = this.likes;
        this.liked = liked;
        this.likes += liked ? 1 : -1;
        fetch(`../recipe/saveRecipe.php?code=${liked ? 1 : 0}&recipe_id=<?php echo (int) $recipe['id'] ?>`)
          .then((res) => res.json())
          .then((success) => {
            if (!success) {
              throw new Error("Could not update saved recipe.");
            }
          })
          .catch((error) => {
            this.liked = previousLiked;
            this.likes = previousLikes;
            console.error("Error saving recipe:", error);
          });
      }
    }
  }).mount('#recipe-<?php echo $recipe['id'] ?>');
</script>

