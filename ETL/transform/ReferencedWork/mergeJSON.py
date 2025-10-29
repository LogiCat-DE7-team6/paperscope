# 각자 수집한 json 파일을 합치는 코드

import ijson
import json
from pathlib import Path

input_files = sorted(Path("./raw_data").glob("*.json"))
output_file = "./raw_data/merged_works.json"

total_items = 0  # 누적 데이터 수
print(f"병합할 파일 수: {len(input_files)}개")

with open(output_file, "w", encoding="utf-8") as outfile:
    outfile.write("[\n")
    first = True
    for idx, file in enumerate(input_files, 1):
        print(f"[{idx}/{len(input_files)}] {file.name} 처리 중...")
        count = 0
        with open(file, "r", encoding="utf-8") as f:
            for item in ijson.items(f, "item", use_float=True):
                if not first:
                    outfile.write(",\n")
                json.dump(item, outfile, ensure_ascii=False)
                first = False
                count += 1
                total_items += 1
        print(f"{file.name} 처리 완료 ({count:,}개 추가, 누적 {total_items:,}개)")
    outfile.write("\n]")

print(f"\n{output_file} 병합 완료 (총 {total_items:,}개)")

'''
병합할 파일 수: 4개
[1/4] works_20250801_20250820.json 처리 중...
works_20250801_20250820.json 처리 완료 (37,079개 추가, 누적 37,079개)
[2/4] works_20250911_20250930.json 처리 중...
works_20250911_20250930.json 처리 완료 (34,033개 추가, 누적 71,112개)
[3/4] works_20251001_20251022.json 처리 중...
works_20251001_20251022.json 처리 완료 (36,204개 추가, 누적 107,316개)
[4/4] works_250821_250910.json 처리 중...
works_250821_250910.json 처리 완료 (39,721개 추가, 누적 147,037개)

merged_works.json 병합 완료 (총 147,037개)
'''