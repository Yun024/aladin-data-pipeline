# 데이터 웨어하우스를 이용한 대시보드 구성
### 주제: 알라딘API를 이용한 데이터 파이프라인 구성 및 대시보드 시각화
**Team: 파이브라인** | 2024.12.26 ~ 2025.01.10
  + `윤여준`: 데이터 수집 및 전처리, S3/Snowflake 데이터 적재, Superset 대시보드 데이터 시각화
  + `김경영`: 데이터 수집 및 전처리, S3/Snowflake 데이터 적재, Superset 대시보드 데이터 시각화
  + `윤병훈`: 데이터 수집 및 전처리, S3/Snowflake 데이터 적재, Superset 대시보드 데이터 시각화
  + `이은지`: 데이터 수집 및 전처리, S3/Snowflake 데이터 적재, Superset 대시보드 데이터 시각화

# 목차
1. 분석배경 및 목표<br>
2. 데이터 파이프라인 아키텍처 & ERD<br>
3. 기술 스택 & 데이터 소스<br>
4. 프로젝트 세부 결과<br>
5. 결론<br>

# 분석배경 및 목표 
 도서 시장은 사회적 트렌드와 독자의 관심에 따라 변화하며, 베스트셀러 데이터는 이를 분석하는 중요한 지표가 됩니다. 본 프로젝트는 도서 시장의 흐름을 정량적으로 분석하여 출판업계와 독자들에게 유용한 인사이트를 제공하는 것을 목표로 합니다. 베스트셀러 목록을 활용해 인기 장르와 주제, 저자의 흐름을 파악하고, 이를 통해 독서 트렌드와 시장 변화를 예측합니다. 또한, 출판사와 저자를 위한 마케팅 전략 수립에 활용하고, 사회적·문화적 흐름을 반영하는 독자들의 관심사를 분석합니다.
 
 더불어, 독자 리뷰 데이터를 분석하여 도서별 반응과 만족도를 파악하고, 긍정·부정 요소를 도출해 독서 경험을 개선할 수 있도록 합니다. 나아가, 독서 패턴과 선호도를 기반으로 개인 맞춤형 추천 시스템을 개발하여 독자들에게 더욱 효율적인 도서 탐색 환경을 제공합니다.

# 데이터 파이프라인 아키텍처 & ERD
## 데이터 파이프라인 아키텍처
<img width="701" alt="image" src="https://github.com/user-attachments/assets/951be074-c3df-4b8f-b175-cdccad37ad2b" />

## ERD
<img width="705" alt="image" src="https://github.com/user-attachments/assets/7ee900da-5404-4d5d-8871-94bb82cb49b8" />

# 기술스택 & 데이터 소스
### Language
`Python` `SQL`

### ETL
`Pandas` `AWS S3` `Snowflake`

### BI Tool
`Apache Superset` `ERD Cloud`

### Collab
`Github` `Slack` `Zep` `Notion`
  
### 데이터 소스
`Aladin API`

# 프로젝트 세부결과
## 데이터 수집 및 전처리
<details>
  <summary>데이터 수집 개요</summary>
  
  - 소스 데이터: 알라딘 도서 API
    - 상품 리스트 API: 주차별 베스트 셀러 Top 50 데이터
    - 상품 조회 API: 각 도서의 고유 정보
  - 수집 기간
    - 2023년 1월 첫째 주 ~ 2024년 12월 넷째 주
    - 총 2년간의 주차별 베스트셀러 데이터
</details>

<details>
  <summary>데이터 수집 과정</summary>
  
- 상품 리스트 API 호출
    - 주차 별 베스트셀러 Top50 목록 수집
    - 주차 별 응답 데이터를 하나의 배열로 통합해서 Parquet 형식으로 저장
- 상품 조회 API 호출
    - 각 도서의 고유값(ISBN13)을 이용하여 도서 별 상세정보 호출
    - 모든 도서 정보를 하나의 배열로 통합해서 Parquet 형식으로 저장
</details>

<details>
  <summary>API 호출 특징</summary>
  
- 사용 언어 **`Python`**
- 코드 구조
    - 상품 리스트 API 호출 코드 **`aladin_data.py`**
    - 상품 조회 API 호출 코드 **`request_product_info.py`**
    - 전체 워크 플로우 관리 **`main.py`**
</details>

<details>
  <summary>데이터 적재</summary>
  
- 스토리지 **`Amazon S3`**
    - 버킷 생성 및 데이터 업로드
- 최종 저장 파일
    - 상품 리스트 데이터 **`weekly_besetseller.parquet`**
    - 상품 조회 데이터 **`book_detail.parquet`**
</details>

## 데이터 웨어하우스 설계 및 적재
<details>
  <summary>데이터 저장 방식</summary>
  
- 파일 저장
    - S3의 파일을 그대로 Snowflake의 단일 테이블에 적재
    - Parquet 파일을 Snowflake로 로드하여 데이터 처리 효율성 확보
- 뷰(View) 활용
    - Raw 데이터를 가공하여 필요한 분석 및 시각화를 위해 뷰 생성
    - Superset에서 활용하기에 용이
</details>

<details>
  <summary>스키마 설계</summary>
  
- Raw 데이터 스키마(raw_data)
    - 두 개의 Parquet 파일 데이터를 단일 테이블로 저장
    - 원본 데이터 형태 유지
- 분석용 스키마(analytics)
    - Raw 데이터를 기반으로 분석과 시각화를 위한 뷰 구성
    - 뷰 생성 예시
    - monthly_sales: 월별 도서 판매량
    - monthly_bestseller: 월별 베스트셀러
</details>

<details>
  <summary>베스트셀러 데이터 기반 테이블 설계 및 생성</summary>
  
- **도서정보(Books)**: `ISBN13` **PK**  
- **서브정보(SubInfo)**: `ISBN13` **FK**, 각 테이블 `ID` **PK**  
  - 포장, 판매, 리뷰, 랭킹, 전자책, 중고책, 중고 매입  
- **시리즈/카테고리**: `SeriesID`, `CategoryID` **PK**, `ISBN13` **FK**  
- CSV/Parquet 기반 ERD 설계 및 테이블 생성
</details>

## 인사이트 도출 및 대시보드 설계
<details>
  <summary>관리자용 대시보드</summary>
  
- **목적**: 영업 전략 수립 및 마케팅
- **구성**
  - 월별 총 판매량
  - 카테고리별 판매량(전년도 대비 증감율/ 2024 카테고리 판매량)
  - 작년 동기 대비 총 매출액 (Year/Quarter/Month)
  - 매출액 기준 작년 동기 대비 증감율(YoY/ QoQ/ MoM)
 <img width="701" alt="image" src="https://github.com/user-attachments/assets/67c1e9ea-2fb8-4442-95cd-9a7f19df38cf" />
</details>

<details>
  <summary>사용자 대시보드</summary>
  
- **목적**: 도서 선택 및 구매 의사결정을 지원
- **구성**
  - 베스트셀러(2024 Top20/ 2024 월별 베스트 셀러)
  - 인기 카테고리(2024 인기 카테고리/ 월별 인기 카테고리)
  - 2024 1위 빈도 Top 10
  - 도서 카테고리 정보
<img width="701" alt="image" src="https://github.com/user-attachments/assets/7cfb6466-5558-4b63-b88d-20382f35690d" />
</details>

# 결론
## 📌 기대효과
- 도서 시장의 트렌드와 독서 패턴을 파악하여 출판사 및 독자에게 유용한 인사이트 제공
- 독서 맞춤형 추천 시스템을 통해 도서 선택 과정 개선
- 판매량 예측 모델을 통해 출판사 및 유통사에 미래 시장 준비 기회 제공

## 🔄 개선점
✅	**실시간 데이터 수집**
  + API 호출 자동화를 위한 Airflow 파이프라인 구축
  + 신간 및 베스트셀러 데이터 실시간 업데이트

✅	**고급 분석**

- Sentiment Analysis: 리뷰 데이터를 기반으로 독자들의 긍정적/부정적 반응 분석
- Word Cloud: 리뷰 키워드를 시각화하여 독자 관심사를 한눈에 파악

✅	**시각화 개선**

- 사용자 인터랙션 지원 강화: 필터를 통해 특정 카테고리 또는 월 데이터를 선택
- GeoJSON을 활용한 지역별 도서 판매량 시각화

✅	**사용자 추천 시스템**

- 도서 리뷰와 판매 데이터를 기반으로 추천 알고리즘 개발
- K-Nearest Neighbors(KNN) 및 협업 필터링 기법 활용

