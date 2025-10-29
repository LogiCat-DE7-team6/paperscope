# 설계한 ReferencedWork 테이블에 맞게 json 파일을 csv 파일로 변환하는 코드

import pandas as pd
import json

with open("./raw_data/referenced_top100.json", "r", encoding="utf-8") as f:
    data = json.load(f)

rows = []
for w in data:
    # 저자 / 기관 정보 안전하게 추출
    authorships = w.get("authorships") or []
    if len(authorships) > 0:
        first_author_id = authorships[0].get("author", {}).get("id")
        first_institutions = authorships[0].get("institutions") or []
        first_institution_id = first_institutions[0].get("id") if len(first_institutions) > 0 else None
    else:
        first_author_id = None
        first_institution_id = None

    # primary_topic_id 안전하게 처리
    primary_topic = w.get("primary_topic") or {}
    primary_topic_id = None
    if primary_topic.get("id"):
        primary_topic_id = primary_topic["id"].split("/")[-1]

    # work_id도 같은 방식으로 처리
    work_id = None
    if w.get("id"):
        work_id = w["id"].split("/")[-1]

    rows.append({
        "work_id": work_id,
        "title": w.get("title") or w.get("display_name") or None,
        "doi": w.get("doi") or None,
        "publication_date": w.get("publication_date") or None,
        "type": w.get("type") or None,
        "is_oa": (w.get("open_access") or {}).get("is_oa", None),
        "primary_topic_id": primary_topic_id,
        "domain": (primary_topic.get("domain") or {}).get("display_name", None),
        "field": (primary_topic.get("field") or {}).get("display_name", None),
        "subfield": (primary_topic.get("subfield") or {}).get("display_name", None),
        "citations_past_decade": (
            sum(
                y.get("cited_by_count", 0)
                for y in (w.get("counts_by_year") or [])
                if y.get("year", 0) >= 2015
            ) or None
        ),
        "created_date": w.get("created_date") or None,
        "first_institution_id": (
            first_institution_id.split("/")[-1] if first_institution_id else None
        ),
        "first_author_id": (
            first_author_id.split("/")[-1] if first_author_id else None
        ),
        "keywords": (
            ", ".join([k.get("display_name", "") for k in (w.get("keywords") or [])])
            or None
        ),
        "fwci": w.get("fwci", None),
        "reference_count_in_source": w.get("reference_count_in_source", None)
    })

df = pd.DataFrame(rows)
#df.to_csv("./raw_data/referenced_work.csv", index=False, encoding="utf-8-sig")
df.to_csv("./raw_data/referenced_work_with_cnt.csv", index=False, encoding="utf-8-sig")

#print("referenced_work.csv 저장 완료")
print("referenced_work_with_cnt.csv 저장 완료")