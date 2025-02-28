import os
import pandas as pd
import json

def convert_product_info_json_to_parquet(json_directory:str="product_info", parquet_directory:str="product_info_parquet"):
    """
    JSON 파일을 순회하며 Parquet 파일로 변환하는 함수.

    Args:
        json_directory (str): JSON 파일이 저장된 디렉토리 경로.
        parquet_directory (str): 변환된 Parquet 파일을 저장할 디렉토리 경로.
    """
    # Parquet 저장 디렉토리 생성
    os.makedirs(parquet_directory, exist_ok=True)

    # JSON 파일을 순회하며 변환
    for file_name in os.listdir(json_directory):
        if file_name.endswith(".json"):
            json_file_path = os.path.join(json_directory, file_name)
            parquet_file_path = os.path.join(parquet_directory, file_name.replace(".json", ".parquet"))

            try:
                # JSON 파일 읽기
                with open(json_file_path, "r", encoding="utf-8") as file:
                    data = json.load(file)
                
                # JSON 데이터를 Pandas DataFrame으로 변환
                if "item" in data:  # 'item' 키가 있는 경우만 처리
                    df = pd.json_normalize(data["item"])
                    
                    # Parquet 파일로 저장
                    df.to_parquet(parquet_file_path, index=False, engine="pyarrow")
                    print(f"Converted {file_name} to {parquet_file_path}")
                else:
                    print(f"'item' key not found in {file_name}. Skipping...")
            except Exception as e:
                print(f"Failed to process {file_name}: {e}")

# 메인 함수 실행
if __name__ == "__main__":
    # JSON 파일 디렉토리와 Parquet 저장 디렉토리 설정
    json_directory = "product_info"
    parquet_directory = "product_info_parquet"
    
    # 함수 호출
    convert_product_info_json_to_parquet(json_directory, parquet_directory)
