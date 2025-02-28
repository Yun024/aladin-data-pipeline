------------------------ CREATE TABLE
-- bestseller
CREATE OR REPLACE TABLE dev.raw_data.bestseller(
    title VARCHAR NOT NULL,
    link VARCHAR NULL,
    author VARCHAR NULL,
    pubDate	VARCHAR NULL,
	description	VARCHAR	NULL,
	isbn VARCHAR(10) NULL,
    isbn13 VARCHAR(13) NULL,
    itemId NUMBER NULL,
    priceSales NUMBER NULL,
    priceStandard NUMBER NULL,
    mallType VARCHAR NULL,
    stockStatus	VARCHAR	NULL,
    mileage	NUMBER NULL,
    cover VARCHAR NULL,
    categoryId NUMBER NULL,
    categoryName VARCHAR NULL,
    publisher VARCHAR NULL,
    salesPoint NUMBER NULL,
    adult BOOLEAN NULL,
    fixedPrice BOOLEAN NULL,
    customerReviewRank NUMBER NULL,
    bestDuration VARCHAR NULL,
	bestRank NUMBER NULL,
    "seriesInfo.seriesId"	FLOAT NULL,
	"seriesInfo.seriesLink" VARCHAR NULL,
	"seriesInfo.seriesName" VARCHAR NULL,
    Year NUMBER NULL,
	Month NUMBER NULL,
	Week NUMBER NULL
);

COPY INTO dev.raw_data.bestseller
FROM 's3://yeojun-test-bucket/aladin/merged_bestseller_parquet.parquet'
credentials = (AWS_KEY_ID='AWS_ACCESS_KEY' AWS_SECRET_KEY='AWS_SECRET_KEY')
FILE_FORMAT = (type='parquet') 
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

select * from dev.raw_data.bestseller;

DROP TABLE dev.raw_data.bestseller;
TRUNCATE TABLE dev.raw_data.bestseller;

-- book_info

CREATE OR REPLACE TABLE dev.raw_data.book_info(
    title VARCHAR NOT NULL,
    link VARCHAR NULL,
    author VARCHAR NULL,
    pubDate	VARCHAR NULL,
	description	VARCHAR	NULL,
	isbn VARCHAR(10) NULL,
    isbn13 VARCHAR(13) NULL,
    itemId NUMBER NULL,
    priceSales NUMBER NULL,
    priceStandard NUMBER NULL,
    mallType VARCHAR NULL,
    stockStatus	VARCHAR	NULL,
    mileage	NUMBER NULL,
    cover VARCHAR NULL,
    categoryId NUMBER NULL,
    categoryName VARCHAR NULL,
    publisher VARCHAR NULL,
    salesPoint NUMBER NULL,
    adult BOOLEAN NULL,
    fixedPrice BOOLEAN NULL,
    customerReviewRank NUMBER NULL,
    "subInfo.ebookList" VARIANT NULL,
    "subInfo.usedList.aladinUsed.itemCount" NUMBER NULL,
    "subInfo.usedList.aladinUsed.minPrice" NUMBER NULL,
    "subInfo.usedList.aladinUsed.link" VARCHAR NULL,
    "subInfo.usedList.userUsed.itemCount" NUMBER NULL,
    "subInfo.usedList.userUsed.minPrice" NUMBER NULL,
    "subInfo.usedList.userUsed.link" VARCHAR NULL,
    "subInfo.usedList.spaceUsed.itemCount" NUMBER NULL,
    "subInfo.usedList.spaceUsed.minPrice" NUMBER NULL,
    "subInfo.usedList.spaceUsed.link" VARCHAR NULL,
    "subInfo.subTitle" VARCHAR NULL,
    "subInfo.originalTitle" VARCHAR NULL,
    "subInfo.itemPage" NUMBER NULL,
    "subInfo.cardReviewImgList" VARIANT NULL,
    "subInfo.ratingInfo.ratingScore" DOUBLE NULL,
    "subInfo.ratingInfo.ratingCount" NUMBER NULL,
    "subInfo.ratingInfo.commentReviewCount" NUMBER NULL,
    "subInfo.ratingInfo.myReviewCount" NUMBER NULL,
    "subInfo.bestSellerRank" VARCHAR NULL,
    "subInfo.packing.styleDesc" VARCHAR NULL,
    "subInfo.packing.weight" NUMBER NULL,
    "subInfo.packing.sizeDepth" NUMBER NULL,
    "subInfo.packing.sizeHeight" NUMBER NULL,
    "subInfo.packing.sizeWidth" NUMBER NULL,
    "subInfo.c2bsales" NUMBER NULL,
    "subInfo.c2bsales_price.AA" NUMBER NULL,
    "subInfo.c2bsales_price.A" NUMBER NULL,
    "subInfo.c2bsales_price.B" NUMBER NULL,
    "subInfo.c2bsales_price.C" NUMBER NULL,
    "subInfo.subBarcode" VARCHAR NULL,
    "seriesInfo.seriesId" DOUBLE NULL,
    "seriesInfo.seriesLink" VARCHAR NULL,
    "seriesInfo.seriesName" VARCHAR NULL
);

COPY INTO dev.raw_data.book_info
FROM 's3://yeojun-test-bucket/aladin/merged_product_info.parquet'
credentials = (AWS_KEY_ID='AWS_ACCESS_KEY' AWS_SECRET_KEY='AWS_SECRET_KEY')
FILE_FORMAT = (type='parquet') 
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

select * from dev.raw_data.book_info;

