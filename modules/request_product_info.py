import os
import json
import requests
import time
from extract_ISBN import extract_isbn

def get_bookInfo(key:str):
    isbn = extract_isbn("bestseller_data")
    OptResult = "ratingInfo,ebookList,usedList,fileFormatList,c2binfo,packing,b2bSupply,subbarcode,cardReviewImgList,bestSellerRank" #reviewList" #"ebookList","usedList",
    Version = 20131101
    # 저장 디렉토리 설정
    directory = "product_info"
    os.makedirs(directory, exist_ok=True)

    MAX_RETRIES = 3  # 최대 재시도 횟수

    for i in isbn:
        url = f"http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey={key}&itemIdType=ISBN&ItemId={i}&output=JS&Version={Version}&OptResult={OptResult}"
        
        for attempt in range(MAX_RETRIES):
            try:
                # API 요청
                response = requests.get(url, timeout=10)  # 타임아웃 설정

                if response.status_code == 200:
                    # 응답을 JSON 형태로 변환
                    response_json = response.json()

                    # 파일 이름 생성
                    file_name = f"{i}_product_info.json"
                    file_path = os.path.join(directory, file_name)

                    # JSON 데이터를 파일로 저장
                    with open(file_path, "w", encoding="utf-8") as file:
                        json.dump(response_json, file, ensure_ascii=False, indent=4)

                    print(f"Saved product_info Data: {file_name}")
                    break  # 성공하면 루프 종료
                else:
                    print(f"Request failed for ISBN: {i} with status code {response.status_code}")
            except (requests.exceptions.Timeout, requests.exceptions.ConnectionError) as e:
                print(f"Attempt {attempt + 1} failed for ISBN: {i} with error: {e}")
                time.sleep(2)  # 재시도 전 대기
            except json.JSONDecodeError:
                print(f"Failed to decode JSON for ISBN: {i}")
                break  # JSON 문제는 재시도할 필요 없음
        time.sleep(0.1)
