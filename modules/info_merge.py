import os
import pandas as pd
import pyarrow.parquet as pq

def merge_parquet_files(input_directory: str, output_file: str):
    # 디렉토리 내 모든 parquet 파일 목록 가져오기
    parquet_files = [os.path.join(input_directory, f) for f in os.listdir(input_directory) if f.endswith('.parquet')]
    
    # 첫 번째 파일 로드하여 스키마 기준으로 데이터 프레임 초기화
    first_file = parquet_files[0]
    df = pd.read_parquet(first_file)
    
    # 첫 번째 파일의 컬럼 이름을 기준으로 병합 진행
    for file in parquet_files[1:]:
        current_df = pd.read_parquet(file)
        
        # 컬럼이 없으면 null을 추가하고, 새로운 컬럼은 무시
        for column in df.columns:
            if column not in current_df.columns:
                current_df[column] = pd.NA
        
        # 첫 번째 파일과 같은 스키마를 가진 데이터프레임으로 병합
        df = pd.concat([df, current_df], ignore_index=True)
    
    # 병합된 데이터프레임을 하나의 parquet 파일로 저장
    df.to_parquet(output_file)