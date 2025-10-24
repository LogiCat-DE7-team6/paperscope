from pyalex import Works
import pyalex
import json
import time

pyalex.config.email = "pea1101ce@gmail.com"

start_time = time.time()

# 1️. 필터 설정
works = Works().filter(
    topics={"field": {"id":'17'}},
    from_publication_date="2025-09-11",
    to_publication_date="2025-09-30"
)

# 2️. 페이지네이터 설정
pager = works.paginate(per_page=200, n_max=None)

data = []
count = 0

# 3️. 페이지 단위로 순회하며 JSON 데이터 수집
for page in pager:
    data.extend(page)
    count += len(page)
    print(f"누적 수집: {count}개")

# 4️. JSON 파일로 저장
with open("openalex_cs_2025_09_11_to_09_30.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

elapsed = time.time() - start_time
print(f"\n저장 완료: {count}개 works")
print(f"총 소요 시간: {elapsed:.2f}초 ({elapsed/60:.2f}분)")
