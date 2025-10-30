-- 테이블 생성
CREATE OR REPLACE TABLE dev.raw_data.work (
    work_id VARCHAR(32) PRIMARY KEY,
    title string NULL,
    doi string NULL,
    publication_date DATE NULL,
    type string NULL COMMENT 'article, book 등',
    is_oa BOOLEAN NULL,
    primary_topic_id VARCHAR(32) NULL COMMENT 'primary_topic.id',
    domain string NULL COMMENT 'primary_topic.domain.display_name',
    field string NULL COMMENT 'primary_topic.field.display_name',
    subfield string NULL COMMENT 'primary_topic.subfield.display_name',
    citations_past_decade INT NULL COMMENT 'counts_by_year의 모든 cited_by_count 값 sum',
    created_date DATE NULL,
    first_institution_id VARCHAR(32) NULL COMMENT 'authorships.institutions.id',
    first_author_id VARCHAR(32) NULL COMMENT 'authorships.author.id',
    keywords string NULL COMMENT 'keywords 의 display_name CONCAT'
);

CREATE OR REPLACE TABLE dev.raw_data.author (
    author_id VARCHAR(32) PRIMARY KEY,
    author_name string NULL COMMENT 'display_name',
    orcid VARCHAR(50) NULL,
    works_count INT NULL,
    cited_by_count INT NULL,
    institution_id VARCHAR(15) NULL COMMENT '저자가 속한 기관ID (가장 최신 논문 기준)/last_known_institutions.id'
);

CREATE OR REPLACE TABLE dev.raw_data.work_author (
    work_id VARCHAR(32) NOT NULL,
    author_id VARCHAR(32) NOT NULL,
    author_position string NULL COMMENT '1저자:first, 2저자~N-1저자 : middle, N저자 : last/ work의 authorships.author_position'
);

CREATE OR REPLACE TABLE dev.raw_data.institution (
    institution_id VARCHAR(32) PRIMARY KEY,
    institution_name string NOT NULL COMMENT 'display_name',
    country_code VARCHAR(8) NULL,
    type string NULL,
    geo_lat FLOAT NULL COMMENT 'geo.latitude',
    geo_lon FLOAT NULL COMMENT 'geo.longitude',
    works_count INT NULL,
    cited_by_count INT NULL COMMENT '해당 기관에서 제출된 논문의 피인용수 총합'
);

CREATE OR REPLACE TABLE dev.raw_data.topic (
    topic_id VARCHAR(32) PRIMARY KEY,
    topic string NOT NULL COMMENT 'display_name',
    domain string NULL COMMENT 'domain.display_name',
    field string NULL COMMENT 'field.display_name',
    subfield string NULL COMMENT 'subfield.display_name',
    works_count INT NULL COMMENT '해당 토픽으로 태그된 논문의 총 개수',
    cited_by_count INT NULL COMMENT '해당 토픽으로 태그된 모든 논문들이 받은 인용 수'
);

CREATE OR REPLACE TABLE dev.raw_data.work_topic (
    work_id VARCHAR(32) NOT NULL,
    topic_id VARCHAR(32) NOT NULL,
    score FLOAT NULL COMMENT '연관도 점수',
    topic_order INTEGER NULL COMMENT '1~3'
);

CREATE OR REPLACE TABLE dev.raw_data.work_keyword (
    work_id VARCHAR(32) NOT NULL,
    keyword string NULL
);

CREATE OR REPLACE TABLE dev.raw_data.referencedwork (
    work_id VARCHAR(32) PRIMARY KEY,
    title string NOT NULL,
    doi string NULL,
    publication_date DATE NULL,
    type string NULL COMMENT 'article, book 등',
    is_oa BOOLEAN NULL,
    primary_topic_id VARCHAR(32) NULL COMMENT 'primary_topic.id',
    domain string NULL COMMENT 'primary_topic.domain.display_name',
    field string NULL COMMENT 'primary_topic.field.display_name',
    subfield string NULL COMMENT 'primary_topic.subfield.display_name',
    citations_past_decade INT NULL COMMENT 'counts_by_year의 모든 cited_by_count 값 sum',
    created_date DATE NULL,
    first_institution_id VARCHAR(32) NULL,
    first_author_id VARCHAR(32) NULL,
    keywords string NULL COMMENT 'keywords 의 display_name CONCAT',
    fwci FLOAT NULL,
    reference_count_in_source INT NULL COMMENT 'work 기준 참조 건수'
);

-- COPY INTO로 벌크 업데이트
COPY INTO dev.raw_data.work
FROM 's3://logicat-2ndproj-bucket/raw_data/work.csv'
CREDENTIALS=(AWS_KEY_ID='***' AWS_SECRET_KEY='***')
FILE_FORMAT=(TYPE='CSV' SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"')
ON_ERROR='CONTINUE';

COPY INTO dev.raw_data.author
FROM 's3://logicat-2ndproj-bucket/raw_data/author.csv'
CREDENTIALS=(AWS_KEY_ID='***' AWS_SECRET_KEY='***')
FILE_FORMAT=(TYPE='CSV' SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

COPY INTO dev.raw_data.work_author
FROM 's3://logicat-2ndproj-bucket/raw_data/work_author.csv'
CREDENTIALS=(AWS_KEY_ID='***' AWS_SECRET_KEY='***')
FILE_FORMAT=(TYPE='CSV' SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

COPY INTO dev.raw_data.institution
FROM 's3://logicat-2ndproj-bucket/raw_data/institution.csv'
CREDENTIALS=(AWS_KEY_ID='***' AWS_SECRET_KEY='***')
FILE_FORMAT=(TYPE='CSV' SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

COPY INTO dev.raw_data.topic
FROM 's3://logicat-2ndproj-bucket/raw_data/topic.csv'
CREDENTIALS=(AWS_KEY_ID='***' AWS_SECRET_KEY='***')
FILE_FORMAT=(TYPE='CSV' SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

COPY INTO dev.raw_data.work_topic (work_id, topic_id, score, topic_order)
FROM 's3://logicat-2ndproj-bucket/raw_data/work_topic.csv'
CREDENTIALS=(AWS_KEY_ID='***' AWS_SECRET_KEY='***')
FILE_FORMAT=(TYPE='CSV' SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

COPY INTO dev.raw_data.work_keyword
FROM 's3://logicat-2ndproj-bucket/raw_data/work_keyword.csv'
CREDENTIALS=(AWS_KEY_ID='***' AWS_SECRET_KEY='***')
FILE_FORMAT=(TYPE='CSV' SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

COPY INTO dev.raw_data.referencedwork
FROM 's3://logicat-2ndproj-bucket/raw_data/referencedwork.csv'
CREDENTIALS=(AWS_KEY_ID='***' AWS_SECRET_KEY='***')
FILE_FORMAT=(TYPE='CSV' SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"');

-- 오류 행 수기 적재
INSERT INTO dev.raw_data.work(
    work_id,
    title,
    doi,
    publication_date,
    type,
    is_oa,
    primary_topic_id,
    domain,
    field,
    subfield,
    citations_past_decade,
    created_date,
    first_institution_id,
    first_author_id,
    keywords
) VALUES (
    'W4414264836',
    'Investigating the Difficulties Encountered by Learners in the Use of Schwa Sound',
    'https://doi.org/10.24093/awej/vol16no3.20',
    '2025-09-16',
    'article',
    FALSE,
    'T10759',
    'Social Sciences',
    'Arts and Humanities',
    'Language and Linguistics',
    0,
    '2025-09-17',
    NULL,
    'A5119644959',
    'Schwa'
);
