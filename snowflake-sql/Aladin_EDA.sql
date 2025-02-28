---------------------------------------------------------------JOIN
-- 월별 도서 판매량
CREATE TABLE dev.analytics.monthly_salepoint AS(
WITH monthly_unique AS(
SELECT DISTINCT title, salespoint, month
FROM dev.raw_data.bestseller)

SELECT month, SUM(salespoint) sum_sp, COUNT(salespoint) cnt_sp
FROM monthly_unique
GROUP BY month
ORDER BY month);

select * from dev.analytics.monthly_salepoint;


-- 카테고리 DISTINCT
SELECT DISTINCT categoryname
FROM dev.raw_data.book_info;

-- 월별 1위 카테고리
CREATE TABLE dev.analytics.monthly_most_popular_cat AS(
WITH monthly_popular_cat AS(
SELECT B.month, A.categoryname, COUNT(A.categoryname) cnt_cat, RANK() OVER(PARTITION BY B.month ORDER BY COUNT(A.categoryname) DESC) rk
FROM dev.raw_data.book_info A
JOIN dev.raw_data.bestseller B on A.isbn = B.isbn
GROUP BY B.month, A.categoryname
ORDER BY B.month, rk)

SELECT * FROM monthly_popular_cat
WHERE rk=1);

SELECT * FROM dev.analytics.monthly_most_popular_cat;

-- 카테고리별 판매량
SELECT COUNT(DISTINCT title), COUNT(title) FROM dev.raw_data.book_info; 

CREATE TABLE dev.analytics.category_salespoint AS(
SELECT categoryname, SUM(salespoint) cat_sp
FROM dev.raw_data.book_info
GROUP BY categoryname
ORDER BY 2 desc);

SELECT * FROM dev.analytics.category_salespoint;

-- 카테고리별 평균 평점
CREATE TABLE dev.analytics.cat_ratingscore AS
SELECT categoryname, ROUND(AVG("subInfo.ratingInfo.ratingScore"),2) cat_rating_avg_score, SUM("subInfo.ratingInfo.ratingCount") cat_rating_sum_count
FROM dev.raw_data.book_info
GROUP BY categoryname
ORDER BY cat_rating_sum_count DESC;

SELECT * FROM dev.analytics.cat_ratingscore;

-- 주간 기준 베스트 셀러 최다 5위까지 
CREATE TABLE dev.analytics.weekly_most_popular_book AS(
SELECT title, count(title) cnt_title
FROM dev.raw_data.bestseller
GROUP BY title
ORDER BY cnt_title DESC);

SELECT * FROM dev.analytics.weekly_most_popular_book;

카테고리 재귀함수
select DISTINCT split_part(categoryname,'>',1) from dev.raw_data.book_info;
select distinct split_part(categoryname,'>',2) from dev.raw_data.book_info;
select DISTINCT split_part(categoryname,'>',3) from dev.raw_data.book_info;
select distinct split_part(categoryname,'>',4) from dev.raw_data.book_info;
select distinct split_part(categoryname,'>',5) from dev.raw_data.book_info;
select distinct split_part(categoryname,'>',6) from dev.raw_data.book_info;

CREATE OR REPLACE TABLE dev.analytics.root_child AS(
select 
distinct 
split_part(categoryname,'>',1) root,
split_part(categoryname,'>',2) child1,
split_part(categoryname,'>',3) child2,
split_part(categoryname,'>',4) child3,
split_part(categoryname,'>',5) child4,
split_part(categoryname,'>',6) child5
from dev.raw_data.book_info);

CREATE TABLE dev.analytics.recursive_cat AS(
WITH RECURSIVE CategoryHierarchy AS (
    -- 초기 계층 (Root 노드 추가)
    SELECT 
        'root' AS id,               -- Root ID
        NULL AS parent,             -- Root는 부모가 없음
        root AS name,               -- Root 이름
        1 AS level                  -- Root의 Level
    FROM dev.analytics.root_child
    GROUP BY root                   -- root는 중복 제거
    
    UNION ALL
    
    -- 재귀적으로 각 child 컬럼을 추가
    SELECT
        CONCAT(ch.id, '-', REPLACE(CASE 
            WHEN ch.level = 1 THEN t.child1
            WHEN ch.level = 2 THEN t.child2
            WHEN ch.level = 3 THEN t.child3
            WHEN ch.level = 4 THEN t.child4
            WHEN ch.level = 5 THEN t.child5
        END, ' ', '_')) AS id,      -- 고유 ID 생성 (중복 방지)
        ch.id AS parent,            -- 상위 노드 ID
        CASE 
            WHEN ch.level = 1 THEN t.child1
            WHEN ch.level = 2 THEN t.child2
            WHEN ch.level = 3 THEN t.child3
            WHEN ch.level = 4 THEN t.child4
            WHEN ch.level = 5 THEN t.child5
        END AS name,                -- 현재 노드 이름
        ch.level + 1 AS level       -- 현재 Level 계산
    FROM 
        CategoryHierarchy ch
    JOIN 
        dev.analytics.root_child t
    ON 
        CASE 
            WHEN ch.level = 1 THEN t.root
            WHEN ch.level = 2 THEN t.child1
            WHEN ch.level = 3 THEN t.child2
            WHEN ch.level = 4 THEN t.child3
            WHEN ch.level = 5 THEN t.child4
        END = ch.name
    WHERE
        (ch.level < 6 AND CASE 
            WHEN ch.level = 1 THEN t.child1
            WHEN ch.level = 2 THEN t.child2
            WHEN ch.level = 3 THEN t.child3
            WHEN ch.level = 4 THEN t.child4
            WHEN ch.level = 5 THEN t.child5
        END IS NOT NULL)
        -- Null 값은 제외
)
SELECT DISTINCT * FROM CategoryHierarchy
ORDER BY LEVEL);


select *
from dev.analytics.recursive_cat
where length(name) != 0 
ORDER BY level ;

