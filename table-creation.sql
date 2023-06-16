/*Tables created with the constraints:

Tabloların Veri Yapısı ve Kısıtlamalar
1. Belirtilen tabloların hepsinde tablo ismine ait id bilgisi PRIMARY KEY olmalıdır.
Tablolar arasında FOREIGN KEY ile referans verilerek ilişki kurulmalıdır.
2. Tüm tablolarda creation_date bilgisi eğer INSERT sorgusunda belirtilmez ise
otomatik olarak verinin eklendiği andaki tarih ve zaman bilgisini eklemelidir.
3. Kullanıcıların username ve email bilgisinin UNIQUE olmasına, aynı zamanda NULL
içerik girilememesine dikkat edilmelidir.
4. Tüm gönderilerin (posts) title ve content bilgisi olmak zorundadır. title bilgisi 50
karakterden uzun olmamalıdır.
5. Bir gönderi herhangi bir view_count bilgisi olmadan kayıt edilirse 0 olarak başlangıç
değerine sahip olmalıdır.
6. Hiçbir gönderi (post) kullanıcı (user) bilgisi olmadan kayıt edilememelidir.
7. Hiçbir gönderi (post) kategori (category) bilgisi olmadan kayıt edilememelidir.
8. Her bir kategori ismi benzersiz (unique) olmalıdır ve NULL olarak kayıt eklenmesi
kısıtlanmalıdır.
9. Hiçbir yorum (comment) gönderi (post) bilgisi olmadan kayıt edilememelidir.
10. Tüm yorumların (comment) comment bilgisi olmak zorundadır.
11. Yorumlar (comment) kullanıcı (user) bilgisi içerebilir veya içermeyebilirler.
*/
CREATE TABLE users(
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(255) UNIQUE NOT NULL,
	email VARCHAR(255) UNIQUE NOT NULL,
	creation_date TIMESTAMP DEFAULT NOW(),
	is_active BOOLEAN
);

CREATE TABLE categories(
	category_id SERIAL PRIMARY KEY,
	name VARCHAR(255) UNIQUE NOT NULL,
	creation_date TIMESTAMP DEFAULT NOW()
);

CREATE TABLE posts(
	post_id SERIAL PRIMARY KEY,
	user_id integer REFERENCES users(user_id) NOT NULL,
	category_id integer REFERENCES categories(category_id) NOT NULL,
	title VARCHAR(50) NOT NULL,
	content TEXT NOT NULL,
	view_count integer DEFAULT 0,
	creation_date TIMESTAMP DEFAULT NOW(),
	is_published BOOLEAN
);

CREATE TABLE comments(
	comment_id SERIAL PRIMARY KEY,
	post_id integer REFERENCES posts(post_id) NOT NULL,
	user_id integer REFERENCES users(user_id),
	comment VARCHAR(255) NOT NULL,
	creation_date TIMESTAMP DEFAULT NOW(),
	is_confirmed BOOLEAN
);


