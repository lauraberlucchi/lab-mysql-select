USE publications;

-- Challenge 1: Who have published what and where?
/* AuthorID, last_name, first_name, TitleID, Title, Publisher
172-32-1176	White	Johnson	PS3333	Prolonged Data Deprivation: Four Case Studies	New Moon Books
213-46-8915	Green	Marjorie	BU1032	The Busy Executive's Database Guide	Algodata Infosystems
213-46-8915	Green	Marjorie	BU2075	You Can Combat Computer Stress!	New Moon Books
238-95-7766	Carson	Cheryl	PC1035	But Is It User Friendly?	Algodata Infosystems
267-41-2394	O'Leary	Michael	BU1111	Cooking with Computers: Surreptitious Balance Sheets	Algodata Infosystems
267-41-2394	O'Leary	Michael	TC7777	Sushi, Anyone?	Binnet & Hardley
274-80-9391	Straight	Dean	BU7832	Straight Talk About Computers	Algodata Infosystems
409-56-7008	Bennet	Abraham	BU1032	The Busy Executive's Database Guide	Algodata Infosystems
427-17-2319	Dull	Ann	PC8888	Secrets of Silicon Valley	Algodata Infosystems
472-27-2349	Gringlesby	Burt	TC7777	Sushi, Anyone?	Binnet & Hardley
486-29-1786	Locksley	Charlene	PC9999	Net Etiquette	Algodata Infosystems
486-29-1786	Locksley	Charlene	PS7777	Emotional Security: A New Algorithm	New Moon Books
648-92-1872	Blotchet-Halls	Reginald	TC4203	Fifty Years in Buckingham Palace Kitchens	Binnet & Hardley
672-71-3249	Yokomoto	Akiko	TC7777	Sushi, Anyone?	Binnet & Hardley
712-45-1867	del Castillo	Innes	MC2222	Silicon Valley Gastronomic Treats	Binnet & Hardley
722-51-5454	DeFrance	Michel	MC3021	The Gourmet Microwave	Binnet & Hardley
724-80-9391	MacFeather	Stearns	BU1111	Cooking with Computers: Surreptitious Balance Sheets	Algodata Infosystems
724-80-9391	MacFeather	Stearns	PS1372	Computer Phobic AND Non-Phobic Individuals: Behavior Variations	Binnet & Hardley
756-30-7391	Karsen	Livia	PS1372	Computer Phobic AND Non-Phobic Individuals: Behavior Variations	Binnet & Hardley
807-91-6654	Panteley	Sylvia	TC3218	Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean	Binnet & Hardley
846-92-7186	Hunter	Sheryl	PC8888	Secrets of Silicon Valley	Algodata Infosystems
899-46-2035	Ringer	Anne	MC3021	The Gourmet Microwave	Binnet & Hardley
899-46-2035	Ringer	Anne	PS2091	Is Anger the Enemy?	New Moon Books
998-72-3567	Ringer	Albert	PS2091	Is Anger the Enemy?	New Moon Books
998-72-3567	Ringer	Albert	PS2106	Life Without Fear	New Moon Books*/

SELECT * FROM authors; 
-- Columns to select: au_id AS AuthorID, au_lname AS last_name, au_fname AS first_name

SELECT * FROM titleauthor;
-- Our table should have 25 rows, as the titleauthor table (or 24 since 1 row is null).
SELECT DISTINCT(title_id) FROM titleauthor; -- There are 17 rows as output of this query: some titles may have more than one author.
SELECT DISTINCT(au_id) FROM titleauthor; -- Check the number of authors: 19 rows - we can exclude the one-to-one relationship between title and author.


DROP TABLE IF EXISTS publications.title_publisher;
-- First I want to assign titles to publishers
CREATE TEMPORARY TABLE title_publisher
SELECT title_id AS TitleID, title AS Title, titles.pub_id AS PublisherID, publishers.pub_name AS Publisher
FROM publications.titles
INNER JOIN publications.publishers ON titles.pub_id = publishers.pub_id
GROUP BY TitleID, Title, PublisherID, Publisher;

SELECT * FROM title_publisher;

DROP TABLE IF EXISTS authors_titles_publisher;
-- Then I join authors to temp table title_publisher
CREATE TEMPORARY TABLE authors_titles_publisher
SELECT authors.au_id AS AuthorID, authors.au_lname AS last_name, authors.au_fname AS first_name,
TitleID, Title, Publisher
FROM publications.title_publisher
LEFT JOIN publications.titleauthor ON title_publisher.TitleID = titleauthor.title_id
INNER JOIN publications.authors ON titleauthor.au_id = authors.au_id
ORDER BY AuthorID ASC;

SELECT * FROM authors_titles_publisher;


-- Challenge 2: Elevating from your solution in Challenge 1, query how many titles each author has published at each publisher.
/* (AuthorID, last_name, first_name, publisher, title_count)
998-72-3567	Ringer	Albert	New Moon Books	2
899-46-2035	Ringer	Anne	Binnet & Hardley	1
899-46-2035	Ringer	Anne	New Moon Books	1
846-92-7186	Hunter	Sheryl	Algodata Infosystems	1
807-91-6654	Panteley	Sylvia	Binnet & Hardley	1
756-30-7391	Karsen	Livia	Binnet & Hardley	1
724-80-9391	MacFeather	Stearns	Algodata Infosystems	1
724-80-9391	MacFeather	Stearns	Binnet & Hardley	1
722-51-5454	DeFrance	Michel	Binnet & Hardley	1
712-45-1867	del Castillo	Innes	Binnet & Hardley	1
672-71-3249	Yokomoto	Akiko	Binnet & Hardley	1
648-92-1872	Blotchet-Halls	Reginald	Binnet & Hardley	1
486-29-1786	Locksley	Charlene	Algodata Infosystems	1
486-29-1786	Locksley	Charlene	New Moon Books	1
472-27-2349	Gringlesby	Burt	Binnet & Hardley	1
427-17-2319	Dull	Ann	Algodata Infosystems	1
409-56-7008	Bennet	Abraham	Algodata Infosystems	1
274-80-9391	Straight	Dean	Algodata Infosystems	1
267-41-2394	O'Leary	Michael	Algodata Infosystems	1
267-41-2394	O'Leary	Michael	Binnet & Hardley	1
238-95-7766	Carson	Cheryl	Algodata Infosystems	1
213-46-8915	Green	Marjorie	Algodata Infosystems	1
213-46-8915	Green	Marjorie	New Moon Books	1
172-32-1176	White	Johnson	New Moon Books	1*/

SELECT AuthorID, last_name, first_name, Publisher,
COUNT(Title) AS title_count
FROM publications.authors_titles_publisher
GROUP BY AuthorID, last_name, first_name, Publisher
ORDER BY AuthorID DESC;

-- Challenge 3: Best selling authors. 
-- Who are the top 3 authors who have sold the highest number of titles?
/* (AuthorID, last_name, first_name, total)
899-46-2035	Ringer	Anne	148
998-72-3567	Ringer	Albert	133
213-46-8915	Green	Marjorie	50*/

SELECT AuthorID, last_name, first_name,
SUM(sales.qty) AS Total
FROM publications.authors_titles_publisher
RIGHT JOIN publications.sales ON authors_titles_publisher.TitleID = sales.title_id
GROUP BY AuthorID, last_name, first_name
ORDER BY Total DESC
LIMIT 3;

-- Challenge 4 - Best Selling Authors Ranking
-- Now modify your solution in Challenge 3 so that the output will display all 23 authors instead of the top 3.
/* AuthorID, last_name, first_name, Total
899-46-2035	Ringer	Anne	148
998-72-3567	Ringer	Albert	133
213-46-8915	Green	Marjorie	50
427-17-2319	Dull	Ann	50
846-92-7186	Hunter	Sheryl	50
267-41-2394	O'Leary	Michael	45
724-80-9391	MacFeather	Stearns	45
722-51-5454	DeFrance	Michel	40
807-91-6654	Panteley	Sylvia	40
238-95-7766	Carson	Cheryl	30
486-29-1786	Locksley	Charlene	25
472-27-2349	Gringlesby	Burt	20
648-92-1872	Blotchet-Halls	Reginald	20
672-71-3249	Yokomoto	Akiko	20
756-30-7391	Karsen	Livia	20
172-32-1176	White	Johnson	15
274-80-9391	Straight	Dean	15
409-56-7008	Bennet	Abraham	15
712-45-1867	del Castillo	Innes	10
341-22-1782	Smith	Meander	0
527-72-3246	Greene	Morningstar	0
724-08-9931	Stringer	Dirk	0
893-72-1158	McBadden	Heather	0*/

SELECT DISTINCT(au_id) FROM titleauthor; -- 17 rows
SELECT DISTINCT(TitleID) FROM publications.authors_titles_publisher; -- 17 rows
SELECT DISTINCT(au_id) FROM authors; 
-- 23 rows: I need to include authors with no title/sales, so I cannot start the join from the temp table created, but I need to start from authors.
-- I could have used the temp table authors_titles_publisher if I had created it with a RIGHT JOIN between authors and titleauthor (line 57).

SELECT authors.au_id AS AuthorID, authors.au_lname AS last_name, authors.au_fname AS first_name,
COALESCE(SUM(sales.qty), 0) AS Total
FROM publications.authors
LEFT JOIN publications.titleauthor ON authors.au_id = titleauthor.au_id
LEFT JOIN publications.sales ON titleauthor.title_id = sales.title_id
GROUP BY AuthorID, last_name, first_name
ORDER BY Total DESC;

