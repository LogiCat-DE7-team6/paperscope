-- 총 논문 수
SELECT
  COUNT(*) AS "총 논문 수"
FROM (
  SELECT
    work_id AS "논문ID",
    title AS "제목",
    doi AS "DOI",
    publication_date AS "출간일",
    CASE
      WHEN type = 'article'
      THEN '학술논문'
      WHEN type = 'book'
      THEN '도서'
      WHEN type = 'book-chapter'
      THEN '도서 챕터'
      WHEN type = 'dissertation'
      THEN '학위논문'
      WHEN type = 'dataset'
      THEN '데이터셋'
      WHEN type = 'report'
      THEN '연구보고서'
      WHEN type = 'preprint'
      THEN '사전출간물'
      WHEN type = 'journal'
      THEN '학술지'
      ELSE '기타'
    END AS "논문유형",
    CASE WHEN is_oa = TRUE THEN '공개' WHEN is_oa = FALSE THEN '구독형' ELSE '정보없음' END AS "공개여부",
    primary_topic_id AS "대표주제ID",
    domain AS "도메인",
    field AS "분야",
    subfield AS "하위분야",
    citations_past_decade AS "피인용수(10년)",
    created_date AS "등록일",
    first_institution_id AS "대표기관ID",
    first_author_id AS "제1저자ID",
    keywords AS "키워드"
  FROM dev.raw_data.work
) AS virtual_table
LIMIT 5000


-- 이번달 발행 논문 수
SELECT
  COUNT(*) AS "이번 달 발행 논문 수"
FROM (
  SELECT
    work_id AS "논문ID",
    title AS "제목",
    doi AS "DOI",
    publication_date AS "출간일",
    CASE
      WHEN type = 'article'
      THEN '학술논문'
      WHEN type = 'book'
      THEN '도서'
      WHEN type = 'book-chapter'
      THEN '도서 챕터'
      WHEN type = 'dissertation'
      THEN '학위논문'
      WHEN type = 'dataset'
      THEN '데이터셋'
      WHEN type = 'report'
      THEN '연구보고서'
      WHEN type = 'preprint'
      THEN '사전출간물'
      WHEN type = 'journal'
      THEN '학술지'
      ELSE '기타'
    END AS "논문유형",
    CASE WHEN is_oa = TRUE THEN '공개' WHEN is_oa = FALSE THEN '구독형' ELSE '정보없음' END AS "공개여부",
    primary_topic_id AS "대표주제ID",
    domain AS "도메인",
    field AS "분야",
    subfield AS "하위분야",
    citations_past_decade AS "피인용수(10년)",
    created_date AS "등록일",
    first_institution_id AS "대표기관ID",
    first_author_id AS "제1저자ID",
    keywords AS "키워드"
  FROM dev.raw_data.work
) AS virtual_table
WHERE
  "출간일" >= CAST('2025-10-01T00:00:00.000000' AS DATETIME)
  AND "출간일" < CAST('2025-10-30T00:38:29.000000' AS DATETIME)
LIMIT 5000


-- 출간 논문 수 잔디
SELECT
  DATE_TRUNC('DAY', "출간일") AS "__timestamp",
  COUNT("논문ID") AS "출간 논문 수"
FROM (
  SELECT
    work_id AS "논문ID",
    title AS "제목",
    doi AS "DOI",
    publication_date AS "출간일",
    CASE
      WHEN type = 'article'
      THEN '학술논문'
      WHEN type = 'book'
      THEN '도서'
      WHEN type = 'book-chapter'
      THEN '도서 챕터'
      WHEN type = 'dissertation'
      THEN '학위논문'
      WHEN type = 'dataset'
      THEN '데이터셋'
      WHEN type = 'report'
      THEN '연구보고서'
      WHEN type = 'preprint'
      THEN '사전출간물'
      WHEN type = 'journal'
      THEN '학술지'
      ELSE '기타'
    END AS "논문유형",
    CASE WHEN is_oa = TRUE THEN '공개' WHEN is_oa = FALSE THEN '구독형' ELSE '정보없음' END AS "공개여부",
    primary_topic_id AS "대표주제ID",
    domain AS "도메인",
    field AS "분야",
    subfield AS "하위분야",
    citations_past_decade AS "피인용수(10년)",
    created_date AS "등록일",
    first_institution_id AS "대표기관ID",
    first_author_id AS "제1저자ID",
    keywords AS "키워드"
  FROM dev.raw_data.work
) AS virtual_table
WHERE
  "출간일" >= CAST('2025-08-01T00:00:00.000000' AS DATETIME)
  AND "출간일" < CAST('2025-10-22T00:00:00.000000' AS DATETIME)
  AND "출간일" >= CAST('2025-08-01T00:00:00.000000' AS DATETIME)
  AND "출간일" < CAST('2025-10-22T00:00:00.000000' AS DATETIME)
GROUP BY
  DATE_TRUNC('DAY', "출간일")
LIMIT 5000


-- 월별 논문 발행
SELECT
  DATE_TRUNC('MONTH', DATE_TRUNC('MONTH', "출간일")) AS "출간일",
  COUNT(*) AS "발행건수"
FROM (
  SELECT
    work_id AS "논문ID",
    title AS "제목",
    doi AS "DOI",
    publication_date AS "출간일",
    CASE
      WHEN type = 'article'
      THEN '학술논문'
      WHEN type = 'book'
      THEN '도서'
      WHEN type = 'book-chapter'
      THEN '도서 챕터'
      WHEN type = 'dissertation'
      THEN '학위논문'
      WHEN type = 'dataset'
      THEN '데이터셋'
      WHEN type = 'report'
      THEN '연구보고서'
      WHEN type = 'preprint'
      THEN '사전출간물'
      WHEN type = 'journal'
      THEN '학술지'
      ELSE '기타'
    END AS "논문유형",
    CASE WHEN is_oa = TRUE THEN '공개' WHEN is_oa = FALSE THEN '구독형' ELSE '정보없음' END AS "공개여부",
    primary_topic_id AS "대표주제ID",
    domain AS "도메인",
    field AS "분야",
    subfield AS "하위분야",
    citations_past_decade AS "피인용수(10년)",
    created_date AS "등록일",
    first_institution_id AS "대표기관ID",
    first_author_id AS "제1저자ID",
    keywords AS "키워드"
  FROM dev.raw_data.work
) AS virtual_table
GROUP BY
  DATE_TRUNC('MONTH', DATE_TRUNC('MONTH', "출간일"))
ORDER BY
  "발행건수" DESC
LIMIT 10000


-- 논문 유형별 발행 비율
SELECT
  "논문유형" AS "논문유형",
  COUNT(*) AS "count"
FROM (
  SELECT
    work_id AS "논문ID",
    title AS "제목",
    doi AS "DOI",
    publication_date AS "출간일",
    CASE
      WHEN type = 'article'
      THEN '학술논문'
      WHEN type = 'book'
      THEN '도서'
      WHEN type = 'book-chapter'
      THEN '도서 챕터'
      WHEN type = 'dissertation'
      THEN '학위논문'
      WHEN type = 'dataset'
      THEN '데이터셋'
      WHEN type = 'report'
      THEN '연구보고서'
      WHEN type = 'preprint'
      THEN '사전출간물'
      WHEN type = 'journal'
      THEN '학술지'
      ELSE '기타'
    END AS "논문유형",
    CASE WHEN is_oa = TRUE THEN '공개' WHEN is_oa = FALSE THEN '구독형' ELSE '정보없음' END AS "공개여부",
    primary_topic_id AS "대표주제ID",
    domain AS "도메인",
    field AS "분야",
    subfield AS "하위분야",
    citations_past_decade AS "피인용수(10년)",
    created_date AS "등록일",
    first_institution_id AS "대표기관ID",
    first_author_id AS "제1저자ID",
    keywords AS "키워드"
  FROM dev.raw_data.work
) AS virtual_table
GROUP BY
  "논문유형"
ORDER BY
  "count" DESC
LIMIT 100


-- 공개 여부
SELECT
  "공개여부" AS "공개여부",
  COUNT(*) AS "count"
FROM (
  SELECT
    work_id AS "논문ID",
    title AS "제목",
    doi AS "DOI",
    publication_date AS "출간일",
    CASE
      WHEN type = 'article'
      THEN '학술논문'
      WHEN type = 'book'
      THEN '도서'
      WHEN type = 'book-chapter'
      THEN '도서 챕터'
      WHEN type = 'dissertation'
      THEN '학위논문'
      WHEN type = 'dataset'
      THEN '데이터셋'
      WHEN type = 'report'
      THEN '연구보고서'
      WHEN type = 'preprint'
      THEN '사전출간물'
      WHEN type = 'journal'
      THEN '학술지'
      ELSE '기타'
    END AS "논문유형",
    CASE WHEN is_oa = TRUE THEN '공개' WHEN is_oa = FALSE THEN '구독형' ELSE '정보없음' END AS "공개여부",
    primary_topic_id AS "대표주제ID",
    domain AS "도메인",
    field AS "분야",
    subfield AS "하위분야",
    citations_past_decade AS "피인용수(10년)",
    created_date AS "등록일",
    first_institution_id AS "대표기관ID",
    first_author_id AS "제1저자ID",
    keywords AS "키워드"
  FROM dev.raw_data.work
) AS virtual_table
GROUP BY
  "공개여부"
ORDER BY
  "count" DESC
LIMIT 100


-- 월별 하위 분야 비율
SELECT
  DATE_TRUNC('MONTH', "PUBLICATION_DATE") AS "PUBLICATION_DATE",
  "SUBFIELD" AS "SUBFIELD",
  SUM("PAPER_COUNT") AS "SUM(PAPER_COUNT)"
FROM (
  SELECT
    publication_date,
    subfield,
    COUNT(work_id) AS paper_count
  FROM work
  WHERE
    NOT publication_date IS NULL
  GROUP BY
    publication_date,
    subfield
  ORDER BY
    publication_date,
    paper_count DESC
) AS virtual_table
JOIN (
  SELECT
    "SUBFIELD" AS "SUBFIELD__",
    SUM("PAPER_COUNT") AS "mme_inner__"
  FROM (
    SELECT
      publication_date,
      subfield,
      COUNT(work_id) AS paper_count
    FROM work
    WHERE
      NOT publication_date IS NULL
    GROUP BY
      publication_date,
      subfield
    ORDER BY
      publication_date,
      paper_count DESC
  ) AS virtual_table
  GROUP BY
    "SUBFIELD"
  ORDER BY
    "mme_inner__" DESC
  LIMIT 10
) AS series_limit
  ON "SUBFIELD" = "SUBFIELD__"
GROUP BY
  DATE_TRUNC('MONTH', "PUBLICATION_DATE"),
  "SUBFIELD"
ORDER BY
  "SUM(PAPER_COUNT)" DESC
LIMIT 10000