# Analysis

## Snowflake 사용 쿼리

### env.sql
기본 환경 설정
- 데이터베이스, 스키마 생성
- user 생성
- 역할 부여 및 역할 권한 설정

### create.sql
S3의 데이터를 COPY INTO로 벌크 업데이트
- erd에 맞춰 테이블 생성
- 데이터 copy into
- 오류 데이터 수기 삽입
