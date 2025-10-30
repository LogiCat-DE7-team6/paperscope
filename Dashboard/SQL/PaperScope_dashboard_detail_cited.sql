-- 최근 많이 인용된 논문 TOP 10
-- 3개월
SELECT
  "제목" AS "제목",
  SUM("피인용수(3개월)") AS "피인용수(3개월)"
FROM (
  SELECT
    r.work_id AS "논문ID",
    r.title AS "제목",
    r.doi AS "DOI",
    r.publication_date AS "출간일",
    CASE
      WHEN r.type = 'article'
      THEN '학술논문'
      WHEN r.type = 'book'
      THEN '도서'
      WHEN r.type = 'book-chapter'
      THEN '도서 챕터'
      WHEN r.type = 'dissertation'
      THEN '학위논문'
      WHEN r.type = 'dataset'
      THEN '데이터셋'
      WHEN r.type = 'report'
      THEN '연구보고서'
      WHEN r.type = 'preprint'
      THEN '사전출간물'
      WHEN r.type = 'journal'
      THEN '학술지'
      ELSE '기타'
    END AS "논문유형",
    CASE WHEN r.is_oa = TRUE THEN '공개' WHEN r.is_oa = FALSE THEN '구독형' ELSE '정보없음' END AS "공개여부",
    r.primary_topic_id AS "대표주제ID",
    t.topic AS "주제",
    r.domain AS "도메인",
    r.field AS "분야",
    r.subfield AS "하위분야",
    r.citations_past_decade AS "피인용수(10년)",
    r.created_date AS "등록일",
    r.first_institution_id AS "대표기관ID",
    i.institution_name AS "대표기관명",
    r.first_author_id AS "제 1저자ID",
    a.author_name AS "제 1저자",
    r.keywords AS "키워드",
    r.fwci AS "FWCI",
    r.reference_count_in_source AS "피인용수(3개월)"
  FROM dev.raw_data.referencedwork AS r
  LEFT JOIN dev.raw_data.topic AS t
    ON r.primary_topic_id = t.topic_id
  LEFT JOIN dev.raw_data.author AS a
    ON r.first_author_id = a.author_id
  LEFT JOIN dev.raw_data.institution AS i
    ON r.first_institution_id = i.institution_id
) AS virtual_table
GROUP BY
  "제목"
ORDER BY
  "피인용수(3개월)" DESC
LIMIT 10

--10년
SELECT
  "제목" AS "제목",
  SUM("피인용수(10년)") AS "피인용수(10년)"
FROM (
  SELECT
    r.work_id AS "논문ID",
    r.title AS "제목",
    r.doi AS "DOI",
    r.publication_date AS "출간일",
    CASE
      WHEN r.type = 'article'
      THEN '학술논문'
      WHEN r.type = 'book'
      THEN '도서'
      WHEN r.type = 'book-chapter'
      THEN '도서 챕터'
      WHEN r.type = 'dissertation'
      THEN '학위논문'
      WHEN r.type = 'dataset'
      THEN '데이터셋'
      WHEN r.type = 'report'
      THEN '연구보고서'
      WHEN r.type = 'preprint'
      THEN '사전출간물'
      WHEN r.type = 'journal'
      THEN '학술지'
      ELSE '기타'
    END AS "논문유형",
    CASE WHEN r.is_oa = TRUE THEN '공개' WHEN r.is_oa = FALSE THEN '구독형' ELSE '정보없음' END AS "공개여부",
    r.primary_topic_id AS "대표주제ID",
    t.topic AS "주제",
    r.domain AS "도메인",
    r.field AS "분야",
    r.subfield AS "하위분야",
    r.citations_past_decade AS "피인용수(10년)",
    r.created_date AS "등록일",
    r.first_institution_id AS "대표기관ID",
    i.institution_name AS "대표기관명",
    r.first_author_id AS "제 1저자ID",
    a.author_name AS "제 1저자",
    r.keywords AS "키워드",
    r.fwci AS "FWCI",
    r.reference_count_in_source AS "피인용수(3개월)"
  FROM dev.raw_data.referencedwork AS r
  LEFT JOIN dev.raw_data.topic AS t
    ON r.primary_topic_id = t.topic_id
  LEFT JOIN dev.raw_data.author AS a
    ON r.first_author_id = a.author_id
  LEFT JOIN dev.raw_data.institution AS i
    ON r.first_institution_id = i.institution_id
) AS virtual_table
GROUP BY
  "제목"
ORDER BY
  SUM("피인용수(3개월)") DESC
LIMIT 10


-- 최근 3개월 최다 인용 논문
SELECT
  "제목" AS "제목",
  "DOI" AS "DOI",
  "출간일" AS "출간일",
  "논문유형" AS "논문유형",
  "공개여부" AS "공개여부",
  "주제" AS "주제",
  "도메인" AS "도메인",
  "분야" AS "분야",
  "하위분야" AS "하위분야",
  "FWCI" AS "FWCI",
  "피인용수(3개월)" AS "피인용수(3개월)",
  "피인용수(10년)" AS "피인용수(10년)",
  "대표기관명" AS "대표기관명",
  "키워드" AS "키워드"
FROM (
  SELECT
    r.work_id AS "논문ID",
    r.title AS "제목",
    r.doi AS "DOI",
    r.publication_date AS "출간일",
    CASE
      WHEN r.type = 'article'
      THEN '학술논문'
      WHEN r.type = 'book'
      THEN '도서'
      WHEN r.type = 'book-chapter'
      THEN '도서 챕터'
      WHEN r.type = 'dissertation'
      THEN '학위논문'
      WHEN r.type = 'dataset'
      THEN '데이터셋'
      WHEN r.type = 'report'
      THEN '연구보고서'
      WHEN r.type = 'preprint'
      THEN '사전출간물'
      WHEN r.type = 'journal'
      THEN '학술지'
      ELSE '기타'
    END AS "논문유형",
    CASE WHEN r.is_oa = TRUE THEN '공개' WHEN r.is_oa = FALSE THEN '구독형' ELSE '정보없음' END AS "공개여부",
    r.primary_topic_id AS "대표주제ID",
    t.topic AS "주제",
    r.domain AS "도메인",
    r.field AS "분야",
    r.subfield AS "하위분야",
    r.citations_past_decade AS "피인용수(10년)",
    r.created_date AS "등록일",
    r.first_institution_id AS "대표기관ID",
    i.institution_name AS "대표기관명",
    r.first_author_id AS "제 1저자ID",
    a.author_name AS "제 1저자",
    r.keywords AS "키워드",
    r.fwci AS "FWCI",
    r.reference_count_in_source AS "피인용수(3개월)"
  FROM dev.raw_data.referencedwork AS r
  LEFT JOIN dev.raw_data.topic AS t
    ON r.primary_topic_id = t.topic_id
  LEFT JOIN dev.raw_data.author AS a
    ON r.first_author_id = a.author_id
  LEFT JOIN dev.raw_data.institution AS i
    ON r.first_institution_id = i.institution_id
) AS virtual_table
ORDER BY
  "피인용수(3개월)" DESC
LIMIT 10