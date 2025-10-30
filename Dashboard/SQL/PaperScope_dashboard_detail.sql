-- 대표 주제별 논문 수
SELECT
  "주제" AS "주제",
  COUNT("논문ID") AS "논문 수"
FROM (
  SELECT
    wt.work_id AS "논문ID",
    t.topic AS "주제",
    wt.score AS score,
    wt.topic_order AS topic_order,
    w.field AS "분야",
    w.subfield AS "하위분야"
  FROM work_topic AS wt
  LEFT JOIN topic AS t
    ON wt.topic_id = t.topic_id
  LEFT JOIN work AS w
    ON wt.work_id = w.work_id
) AS virtual_table
WHERE
  "TOPIC_ORDER" = 1
GROUP BY
  "주제"
ORDER BY
  "논문 수" DESC
LIMIT 10


-- 급상승&감소 연구 TOPIC
SELECT
  "주제" AS "주제",
  AVG("전월 대비 증감률") AS "전월 대비 증감률"
FROM (
  WITH TEMP_TABLE AS (
    SELECT
      A.*,
      (
        (
          CUR_CNT - PREVIOUS_CNT
        ) / PREVIOUS_CNT
      ) * 100 AS "전월 대비 증감률"
    FROM (
      SELECT
        TMP.PRIMARY_TOPIC_ID,
        TMP.P_FIRST_DATE,
        TMP.PT_TOPIC,
        TMP.PT_DOMAIN,
        TMP.PT_FIELD,
        TMP.PT_SUBFIELD,
        COUNT(*) AS CUR_CNT,
        SUM(CUR_CNT) OVER (PARTITION BY TMP.PRIMARY_TOPIC_ID) AS TOTAL_CNT,
        LAG(CUR_CNT) OVER (PARTITION BY TMP.PRIMARY_TOPIC_ID ORDER BY TMP.P_FIRST_DATE) AS PREVIOUS_CNT
      FROM (
        SELECT
          A.*,
          DATE_TRUNC('MONTH', A.PUBLICATION_DATE) AS P_FIRST_DATE,
          MONTH(A.PUBLICATION_DATE) AS PUBLICATION_MONTH,
          B.topic AS PT_TOPIC,
          B.domain AS PT_DOMAIN,
          B.field AS PT_FIELD,
          B.subfield AS PT_SUBFIELD
        FROM work AS A
        LEFT JOIN topic AS B
          ON 1 = 1 AND A.PRIMARY_TOPIC_ID = B.topic_id
      ) AS TMP
      GROUP BY
        TMP.PRIMARY_TOPIC_ID,
        TMP.P_FIRST_DATE,
        TMP.PT_TOPIC,
        TMP.PT_DOMAIN,
        TMP.PT_FIELD,
        TMP.PT_SUBFIELD
    ) AS A
  )
  SELECT
    PRIMARY_TOPIC_ID,
    P_FIRST_DATE,
    PT_TOPIC AS "주제",
    PT_DOMAIN AS "도메인",
    PT_FIELD AS "분야",
    PT_SUBFIELD AS "하위분야",
    CUR_CNT,
    TOTAL_CNT,
    PREVIOUS_CNT,
    "전월 대비 증감률"
  FROM (
    SELECT
      *
    FROM TEMP_TABLE AS A
    WHERE
      A.P_FIRST_DATE = '2025-09-01'
      AND NOT "전월 대비 증감률" IS NULL
      AND "전월 대비 증감률" > 0
      AND TOTAL_CNT > 1000
    ORDER BY
      "전월 대비 증감률" DESC
    LIMIT 5
  )
  UNION
  (
    SELECT
      *
    FROM (
      SELECT
        *
      FROM TEMP_TABLE AS A
      WHERE
        A.P_FIRST_DATE = '2025-09-01' AND NOT "전월 대비 증감률" IS NULL AND TOTAL_CNT > 1000
      ORDER BY
        "전월 대비 증감률"
      LIMIT 5
    )
  )
) AS virtual_table
GROUP BY
  "주제"
ORDER BY
  "전월 대비 증감률" DESC
LIMIT 50


-- 인기 논문 주제
SELECT
  "주제" AS "주제",
  COUNT(*) AS "count"
FROM (
  SELECT
    wt.work_id AS "논문ID",
    t.topic AS "주제",
    wt.score AS score,
    wt.topic_order AS topic_order,
    w.field AS "분야",
    w.subfield AS "하위분야"
  FROM work_topic AS wt
  LEFT JOIN topic AS t
    ON wt.topic_id = t.topic_id
  LEFT JOIN work AS w
    ON wt.work_id = w.work_id
) AS virtual_table
WHERE
  "TOPIC_ORDER" = 1
GROUP BY
  "주제"
LIMIT 100


-- 인기 논문 키워드
SELECT
  "키워드" AS "키워드",
  COUNT("논문ID") AS "논문 수"
FROM (
  SELECT
    wk.keyword AS "키워드",
    wk.work_id AS "논문ID",
    w.field AS "분야",
    w.subfield AS "하위분야"
  FROM raw_data.work_keyword AS wk
  LEFT JOIN raw_data.work AS w
    ON wk.work_id = w.work_id
) AS virtual_table
GROUP BY
  "키워드"
ORDER BY
  "논문 수" DESC
LIMIT 250


-- 저자 작업 피인용 바차트
SELECT
  "저자명" AS "저자명",
  SUM("작성 논문 수") AS "작성 논문 수",
  SUM("피인용 수") AS "피인용 수"
FROM (
  SELECT
    w.field AS "분야",
    w.subfield AS "하위분야",
    a.author_name AS "저자명",
    SUM(a.works_count) AS "작성 논문 수",
    SUM(a.cited_by_count) AS "피인용 수",
    (
      CASE
        WHEN SUM(a.works_count) <> 0
        THEN CAST(SUM(a.cited_by_count) AS FLOAT) / SUM(a.works_count)
      END
    ) AS "작성 대비 피인용 수"
  FROM raw_data.author AS a
  JOIN raw_data.work_author AS wa
    ON wa.author_id = a.author_id
  JOIN raw_data.work AS w
    ON w.work_id = wa.work_id
  WHERE
    NOT works_count IS NULL AND NOT cited_by_count IS NULL
  GROUP BY
    author_name,
    w.field,
    w.subfield
  ORDER BY
    "피인용 수" DESC
) AS virtual_table
GROUP BY
  "저자명"
ORDER BY
  "작성 논문 수" DESC
LIMIT 100


-- 기관 분포 지도
SELECT
  "LATITUDE" AS "LATITUDE",
  "LONGITUDE" AS "LONGITUDE",
  "기관명" AS "기관명",
  SUM("논문수") AS "논문 수"
FROM (
  SELECT
    i.institution_name AS "기관명",
    i.geo_lat AS latitude,
    i.geo_lon AS longitude,
    i.country_code AS "국가코드",
    w.field AS "분야",
    w.subfield AS "하위분야",
    COUNT(w.work_id) AS "논문수"
  FROM dev.raw_data.work AS w
  LEFT JOIN dev.raw_data.institution AS i
    ON w.first_institution_id = i.institution_id
  WHERE
    NOT i.geo_lat IS NULL AND NOT i.geo_lon IS NULL
  GROUP BY
    i.institution_name,
    i.country_code,
    i.geo_lat,
    i.geo_lon,
    w.field,
    w.subfield
  HAVING
    COUNT(w.work_id) > 0
  ORDER BY
    COUNT(w.work_id) DESC
) AS virtual_table
WHERE
  NOT "LATITUDE" IS NULL AND NOT "LONGITUDE" IS NULL
GROUP BY
  "LATITUDE",
  "LONGITUDE",
  "기관명"
ORDER BY
  "논문 수" DESC
LIMIT 1000


-- 국가별 논문 발행 수 MAP
SELECT
  "국가코드" AS "국가코드",
  SUM("논문수") AS "SUM(논문수)"
FROM (
  SELECT
    i.institution_name AS "기관명",
    i.geo_lat AS latitude,
    i.geo_lon AS longitude,
    i.country_code AS "국가코드",
    w.field AS "분야",
    w.subfield AS "하위분야",
    COUNT(w.work_id) AS "논문수"
  FROM dev.raw_data.work AS w
  LEFT JOIN dev.raw_data.institution AS i
    ON w.first_institution_id = i.institution_id
  WHERE
    NOT i.geo_lat IS NULL AND NOT i.geo_lon IS NULL
  GROUP BY
    i.institution_name,
    i.country_code,
    i.geo_lat,
    i.geo_lon,
    w.field,
    w.subfield
  HAVING
    COUNT(w.work_id) > 0
  ORDER BY
    COUNT(w.work_id) DESC
) AS virtual_table
GROUP BY
  "국가코드"
ORDER BY
  "SUM(논문수)" DESC
LIMIT 50000


-- 트리맵 국가코드
SELECT
  "국가코드" AS "국가코드",
  COUNT(*) AS "count"
FROM (
  SELECT
    w.work_id AS "논문_ID",
    w.field AS "분야",
    w.subfield AS "하위분야",
    i.institution_name AS "기관명",
    i.country_code AS "국가코드",
    i.type AS "기관유형",
    i.geo_lat AS "위도 정보",
    i.geo_lon AS "경도 정보",
    i.works_count AS "논문 수",
    i.cited_by_count AS "피인용 수"
  FROM raw_data.work AS w
  JOIN raw_data.institution AS i
    ON w.first_institution_id = i.institution_id
) AS virtual_table
GROUP BY
  "국가코드"
LIMIT 250