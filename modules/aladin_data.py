import os
import json
import requests
import time
import urllib

def get_bestseller(key : str , QueryType : str ="Bestseller", MaxResults : int = 50, Year : int =2024):
    # 저장 디렉토리 설정
    directory = "bestseller_data"
    os.makedirs(directory, exist_ok=True)
    base_url = "http://www.aladin.co.kr/ttb/api/ItemList.aspx"

    # 데이터 요청 및 저장
    for Month in range(1, 13):
        for Week in range(1, 5):
            params = {
                'ttbkey': key,
                'QueryType': QueryType,
                'Year': Year,
                'Month': Month,
                'Week': Week,
                'MaxResults': MaxResults,
                'Start': '1',
                'SearchTarget': 'Book',
                'output': 'JS',
                'Version': '20131101'
            }
            url = f"{base_url}?{urllib.parse.urlencode(params)}"

            # API 요청
            response = requests.get(url)

            if response.status_code == 200:
                try:
                    # 응답을 JSON 형태로 변환
                    response_json = response.json()

                    # 주차 정보를 응답 데이터에 추가
                    response_json['Year'] = Year
                    response_json['Month'] = Month
                    response_json['Week'] = Week

                    # 파일 이름 생성
                    file_name = f"{Year}_Month{Month}_Week{Week}.json"
                    file_path = os.path.join(directory, file_name)

                    # JSON 데이터를 파일로 저장
                    with open(file_path, "w", encoding="utf-8") as file:
                        json.dump(response_json, file, ensure_ascii=False, indent=4)

                    print(f"Saved data for Year: {Year}, Month: {Month}, Week: {Week} to {file_name}")
                except json.JSONDecodeError:
                    print(f"Failed to decode JSON for Year: {Year}, Month: {Month}, Week: {Week}")
            else:
                print(f"Request failed for Year: {Year}, Month: {Month}, Week: {Week} with status code {response.status_code}")
            time.sleep(0.1)
