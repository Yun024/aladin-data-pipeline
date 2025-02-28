import os
import json

def extract_isbn(directory: str = "bestseller_data") -> list:
    """
    주어진 디렉토리에서 JSON 파일을 읽어 ISBN을 추출합니다.

    Args:
        directory (str): JSON 파일이 저장된 디렉토리 경로.

    Returns:
        list: 추출된 ISBN 목록.
    """
    
    # 디렉토리 존재 확인
    if not os.path.exists(directory):
        print(f"Directory '{directory}' does not exist.")
        return []

    isbn_list = []

    # 디렉토리 내 모든 파일 탐색
    for file_name in os.listdir(directory):
        if file_name.endswith(".json"):  # JSON 파일만 처리
            file_path = os.path.join(directory, file_name)

            # 파일 읽기
            with open(file_path, "r", encoding="utf-8") as file:
                try:
                    data = json.load(file)

                    # 'item' 키에서 'isbn' 추출
                    items = data.get("item", [])
                    for item in items:
                        isbn = item.get("isbn")
                        if isbn:
                            isbn_list.append(isbn)
                except json.JSONDecodeError:
                    print(f"Failed to decode JSON in file: {file_name}")
                except Exception as e:
                    print(f"Error processing file {file_name}: {e}")

    # 추출된 ISBN 출력
    print(f"Extracted {len(isbn_list)} ISBN(s): {isbn_list}")

    return isbn_list

