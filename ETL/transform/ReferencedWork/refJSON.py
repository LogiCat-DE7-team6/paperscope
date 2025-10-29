# 상위 100개 referenced_work id의 works 엔티티 데이터를 json 파일로 반환하는 코드

from pyalex import Works
import json
import time

counts_file = "./raw_data/referenced_counts.json"
output_file = "./raw_data/referenced_top100.json"

TOP_N = 100
BATCH_SIZE = 50

with open(counts_file, "r", encoding="utf-8") as f:
    ref_counts = json.load(f)

sorted_refs = sorted(ref_counts.items(), key=lambda x: x[1], reverse=True)
top_refs = sorted_refs[:TOP_N]
ids = [ref_id.split("/")[-1] for ref_id, _ in top_refs]

print(f"상위 {TOP_N:,}개 referenced_works 선택 완료")

all_works = []

for i in range(0, len(ids), BATCH_SIZE):
    batch = ids[i:i + BATCH_SIZE]
    print(f"{i + 1}~{i + len(batch)} 요청 중...")

    results = Works()[batch]

    # 참조 횟수 필드 추가
    for work in results:
        work["reference_count_in_source"] = ref_counts.get(work["id"], 0)

    all_works.extend(results)
    time.sleep(0.3)

with open(output_file, "w", encoding="utf-8") as f:
    json.dump(all_works, f, ensure_ascii=False, indent=2)

print(f"pyalex로 상위 {TOP_N:,}개 referenced_works 수집 완료 → {output_file}")