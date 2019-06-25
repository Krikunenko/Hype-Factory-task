/* Таблица пользователей */
CREATE TABLE `users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(32) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Таблица категорий */
CREATE TABLE `categories` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Таблица постов */
CREATE TABLE `posts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `category_id` INT UNSIGNED NOT NULL,
  `content` VARCHAR(242) NOT NULL, /* в VARCHAR 242 байта на символы и 1 байт на длину */
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `posts_users_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT `posts_categories_fk` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/* Индексы на user_id и category_id, чтобы увеличить скорость запросов для поиска всех постов пользователя или всех постов в категории */

/* Таблица лайков */
CREATE TABLE `likes` (
  `post_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`post_id`, `user_id`),
  CONSTRAINT `likes_posts_fk` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT `likes_users_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Выборка контента */
SELECT p.id,
       p.content,
       p.created_at,
       p.updated_at,
       c.id,
       c.name,
       u.id,
       u.name,
       COALESCE(lc.likes_count, 0)
FROM posts AS p
LEFT JOIN categories AS c ON c.id = p.category_id
LEFT JOIN users AS u ON u.id = p.user_id
LEFT JOIN (SELECT post_id, COUNT(*) AS likes_count FROM likes GROUP BY post_id) AS lc ON lc.post_id = p.id /* на больших объемах данных, чтобы запрос выполнялся быстрее, можно хранить количество лайков в отдельной таблице */
WHERE p.id = 1
ORDER BY p.created_at DESC;

/* Обновление контента */
UPDATE posts SET content = 'Test content' WHERE id = 1;

/* Список всех оценивших пост пользователей */
SELECT l.post_id,
       l.user_id,
       u.name
FROM likes AS l
LEFT JOIN users AS u ON u.id = l.user_id
WHERE l.post_id = 1;

/* Поставить лайк */
INSERT INTO likes (post_id, user_id) VALUES (1, 1);

/* Убрать лайк */
DELETE FROM likes WHERE post_id = 1 AND user_id = 1;