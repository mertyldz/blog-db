--Tüm blog yazılarını başlıkları, yazarları ve kategorileriyle birlikte getirin.
SELECT p.title , u.username, c.name category_name FROM posts p 
JOIN users u ON p.user_id = u.user_id 
JOIN categories c ON p.category_id = c.category_id ;

--En son yayınlanan 5 blog yazısını başlıkları, yazarları ve yayın tarihleriyle birlikte alın.
SELECT title, username, p.creation_date  FROM posts p 
JOIN users u ON p.user_id = u.user_id
ORDER BY 3 DESC;

-- Her blog yazısı için yorum sayısını gösterin.
SELECT p.post_id, p."content", COUNT(c.comment_id) total_comment FROM "comments" c JOIN posts p ON c.post_id = p.post_id GROUP BY p.post_id;

--Tüm kayıtlı kullanıcıların kullanıcı adlarını ve e-posta adreslerini gösterin
SELECT username, email FROM users;

--En son 10 yorumu, ilgili gönderi başlıklarıyla birlikte alın
SELECT p.title, c."comment" FROM "comments" c JOIN posts p ON c.post_id = p.post_id ORDER BY c.creation_date DESC LIMIT 10;

--Belirli bir kullanıcı tarafından yazılan tüm blog yazılarını bulun
SELECT u.username,p.title, p."content"  FROM posts p JOIN users u ON p.user_id = u.user_id  WHERE p.user_id = (SELECT user_id FROM "comments" c GROUP BY user_id ORDER BY COUNT(*) DESC LIMIT 1);

--Her kullanıcının yazdığı toplam gönderi sayısını alın.
SELECT u.username ,COUNT(p.post_id) FROM posts p JOIN users u ON p.user_id = u.user_id GROUP BY u.user_id;

--Her kategoriyi, kategorideki gönderi sayısıyla birlikte gösterin.
SELECT c.category_id, c."name", COUNT(post_id) total_post FROM posts p JOIN categories c ON p.category_id = c.category_id GROUP BY c.category_id;

--Gönderi sayısına göre en popüler kategoriyi bulun
SELECT c.category_id, c."name"  FROM posts p JOIN categories c ON p.category_id = c.category_id GROUP BY c.category_id ORDER BY COUNT(post_id) DESC LIMIT 1;

--Gönderilerindeki toplam görüntülenme sayısına göre en popüler kategoriyi bulun.
SELECT c.category_id, c."name"  FROM posts p JOIN categories c ON p.category_id = c.category_id GROUP BY c.category_id ORDER BY SUM(view_count) DESC LIMIT 1;

--En fazla yoruma sahip gönderiyi alın
SELECT p.title FROM posts p WHERE p.post_id = (SELECT c.post_id FROM "comments" c JOIN posts p ON c.post_id = p.post_id GROUP BY c.post_id ORDER BY COUNT(*) DESC LIMIT 1);

-- Belirli bir gönderinin yazarının kullanıcı adını ve e-posta adresini gösterin
SELECT p."content",u.username, u.email FROM posts p JOIN users u ON p.user_id = u.user_id WHERE post_id = 17;

--Başlık veya içeriklerinde belirli bir anahtar kelime bulunan tüm gönderileri bulun.
SELECT post_id, title, content  FROM posts WHERE title ILIKE '%lorem%' OR CONTENT ILIKE '%lorem%';

--Belirli bir kullanıcının en son yorumunu gösterin.
SELECT u.username , c."comment" FROM "comments" c JOIN users u ON c.user_id = u.user_id WHERE u.user_id = (SELECT user_id FROM users WHERE username LIKE 'b%') ORDER BY c.creation_date DESC LIMIT 1;

--Gönderi başına ortalama yorum sayısını bulun.
SELECT AVG(comment_count) FROM (SELECT p.post_id, COUNT(c.comment_id) comment_count FROM posts p JOIN "comments" c ON c.post_id = p.post_id GROUP BY p.post_id) AS average;

--Son 30 günde yayınlanan gönderileri gösterin.
SELECT p.post_id, p.title, p."content", p.creation_date FROM posts p WHERE (current_timestamp::date - p.creation_date::date) <= 30; -- No posts last 30 days
SELECT p.post_id, p.title, p."content", p.creation_date FROM posts p WHERE (current_timestamp::date - p.creation_date::date) <= 100; -- Checked with 100 days

--Belirli bir kullanıcının yaptığı yorumları alın.
SELECT u.username, c."comment" FROM "comments" c JOIN users u ON c.user_id = u.user_id WHERE u.user_id = (SELECT user_id FROM users ORDER BY creation_date LIMIT 1);

--Belirli bir kategoriye ait tüm gönderileri bulun.
SELECT c."name" category_name,p.title post_title, p.CONTENT post_content FROM posts p JOIN categories c ON p.category_id = c.category_id WHERE c."name" LIKE 'a%';

--5'ten az yazıya sahip kategorileri bulun.
SELECT c."name" category_name,COUNT(p.post_id) total_post FROM categories c JOIN posts p ON p.category_id = c.category_id GROUP BY c.category_id HAVING COUNT(p.post_id) < 5; --All have more than 5 
SELECT c."name" category_name,COUNT(p.post_id) total_post FROM categories c JOIN posts p ON p.category_id = c.category_id GROUP BY c.category_id HAVING COUNT(p.post_id) < 10; --Checked with 10

--Hem bir yazı hem de bir yoruma sahip olan kullanıcıları gösterin.
SELECT u.username FROM users u WHERE u.user_id = ANY((SELECT DISTINCT c.user_id  FROM "comments" c) INTERSECT (SELECT DISTINCT p.user_id FROM posts p));

--En az 2 farklı yazıya yorum yapmış kullanıcıları alın.
SELECT u.username ,COUNT(DISTINCT c.post_id) total_different_comment FROM "comments" c JOIN users u ON c.user_id = u.user_id GROUP BY c.user_id,u.username  HAVING COUNT(DISTINCT c.post_id) >= 2;

--En az 3 yazıya sahip kategorileri görüntüleyin
SELECT c."name" category_name, COUNT(p.post_id) total_post FROM categories c JOIN posts p ON c.category_id = p.category_id GROUP BY c.category_id HAVING COUNT(p.post_id) >= 3;

--5'ten fazla blog yazısı yazan yazarları bulun.
SELECT u.username ,COUNT(p.post_id) total_post FROM posts p JOIN users u ON p.user_id = u.user_id GROUP BY u.user_id HAVING COUNT(p.post_id) > 5;

--Bir blog yazısı yazmış veya bir yorum yapmış kullanıcıların e-posta adreslerini görüntüleyin. (UNION kullanarak)
SELECT u.email FROM users u WHERE u.user_id = ANY ((SELECT DISTINCT p.user_id FROM posts p) UNION (SELECT DISTINCT c.user_id FROM "comments" c));

--Bir blog yazısı yazmış ancak hiç yorum yapmamış yazarları bulun.
SELECT DISTINCT user_id FROM posts p INTERSECT ((SELECT u.user_id FROM users u) EXCEPT (SELECT DISTINCT c.user_id FROM "comments" c));



















