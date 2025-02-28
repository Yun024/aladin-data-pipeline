from dotenv import load_dotenv
import os
import sys

## modules 폴더를 Python경로에 추가
sys.path.append(os.path.join(os.path.dirname(__file__), "modules"))

from aladin_data import get_bestseller
from request_product_info import get_bookInfo
from bestseller_convert_to_parquet import convert_bestseller_json_to_parquet as b_parquet
from bestseller_convert_to_csv import convert_bestseller_json_to_csv as b_csv
from product_info_csv import convert_product_info_json_to_csv as p_csv
from product_info_parquet import convert_product_info_json_to_parquet as p_parquet
from info_merge import merge_parquet_files as m_bp_parquet

def main():   

    # 설정할 매개변수
    load_dotenv("API.env")
    key = os.getenv("Aladdin_KEY")

    QueryType = "Bestseller"  # 옵션: "NewRelease", "Bestseller", "Bestseller_Month", "Bestseller_Year"
    MaxResults = 50  # 최대 결과 개수 (1000 ~ 10000)
    Year = 2024  # 베스트셀러 목록 연도

    # 출력 디렉터리 정의
    bestSeller_json_directory = "bestseller_data"
    bestSeller_parquet_directory = "bestseller_parquet"
    bestSeller_csv_directory = "bestseller_csv"

    productInfo_json_directory = "product_info"
    productInfo_parquet_directory = "product_info_parquet"
    productInfo_csv_directory = "product_info_csv"

    merged_product_file = "merged_product_info.parquet"
    merged_bestseller_file = "merged_bestseller_info.parquet"
    # 베스트셀러 데이터 가져오기 및 JSON 저장
    get_bestseller(key, QueryType, MaxResults, Year)
    
    # 책 정보 가져오기 및 JSON 저장
    get_bookInfo(key)

    # 베스트셀러 JSON을 Parquet와 CSV로 변환
    b_parquet(bestSeller_json_directory, bestSeller_parquet_directory)
    b_csv(bestSeller_json_directory, bestSeller_csv_directory)    
    
    # 제품 정보 JSON을 Parquet와 CSV로 변환
    p_parquet(productInfo_json_directory, productInfo_parquet_directory)
    p_csv(productInfo_json_directory, productInfo_csv_directory)
    
    m_bp_parquet(productInfo_parquet_directory, merged_product_file)
    m_bp_parquet(bestSeller_parquet_directory, merged_bestseller_file)

    print(f"✅베스트셀러 및 도서 정보 수집, 변환, 병합 완료")
    
if __name__ == "__main__":
    main()
