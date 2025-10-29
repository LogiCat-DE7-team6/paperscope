# works의 referenced_works id와 참조 횟수를 json 파일로 반환하는 코드

import ijson
import json
from collections import Counter

input_file = "./raw_data/merged_works.json"
output_ids_file = "./raw_data/referenced_counts.json"

referenced_counter = Counter()
processed = 0

with open(input_file, "r", encoding="utf-8") as f:
    for work in ijson.items(f, "item", use_float=True):
        processed += 1
        if "referenced_works" in work and work["referenced_works"]:
            referenced_counter.update(work["referenced_works"])

        if processed % 10000 == 0:
            print(f"{processed:,}개 처리 완료 (현재 고유 referenced_works: {len(referenced_counter):,}개)")

print(f"\n총 {processed:,}개 works 처리 완료")
print(f"총 {len(referenced_counter):,}개의 고유 referenced_works ID 수집 완료")

with open(output_ids_file, "w", encoding="utf-8") as f:
    json.dump(dict(referenced_counter), f, ensure_ascii=False, indent=2)

print(f"{output_ids_file} 파일에 참조 횟수 저장 완료")

'''
총 147,037개 works 처리 완료
총 1,589,203개의 고유 referenced_works ID 수집 완료
'''