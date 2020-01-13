# chap01_Basic

# 수업내용 
# 1. session 정보
# 2. R 실행방법
# 3. 패키지와 데이터셋
# 4. 변수와 자료형
# 5. 기본함수 사용 및 작업공간

# 1. session 정보
# session : R의 실행환경
sessionInfo()
# R ver, 다국어(locale), base packages

# 2. R 실행방법

# 주요 단축키
# script 실행 : ctrl + enter or ctrl + R
# 자동완성 : ctrl + space
# 저장 : ctrl + s
# 여러 줄 주석 :  ctrl + shift + c(토글)
# a <- 10
# b <- 20
# c <- a+b
# print(c)

# 1) 줄 단위 실행
a <- rnorm(n=20) # <- or =
a
hist(a)
mean(a)

# 2) 블럭 단위 실행
getwd() # 현재 작업 경로 -  "C:/Rwork"
pdf("test.pdf") # open
hist(a) # 히스토그램
dev.off() # close

# 3. 패키지와 데이터셋
# 1) 패키지 = function + [dataset]
# 사용 가능한 패키지 
dim(available.packages()) # 15328(row) 17(col)

# 패키지 설치/사용
install.packages("stringr")
# 패키지 in memory
library(stringr)

# 사용가능한 패키지 확인
search()

# 설치 위치
.libPaths()

# 패키지 활용
str <- "홍길동35이순신45유관순25"
str # [1] "홍길동35이순신45유관순25"

# 이름 추출
str_extract_all(str,"[가-힣]{3}")

# 나이 추출
str_extract_all(str, "[0-9]{2}")

# 패키지 삭제
remove.packages("stringr")

# 2) 데이터셋
data()
data("Nile") # in  memory
Nile
length(Nile)
mode(Nile) # 자료구조 확인 # "numeric"
plot(Nile)
mean(Nile) # 919.35

# 4. 변수와 자료형
# 1) 변수(variable) : 메모리 주소 저장
# - R의 모든 변수는 객체(참조변수)
# - 변수 선언시 type은 없음
a <- c(1:10)
a

# 2) 변수 작성 규칙
# - 첫자는 영문자 
# - 점(.)을 사용(lr.model)
# - 예약어 사용 불가
# - 대소문자 구분 : num or NUM

var1 <- 0 # var1 = 0과 같은 표현
# java) int var1 = 0
var1 <- 1
var1

var2 <- 10
var3 <- 20
var2; var3

# 객체.멤버
member.id <- "hong"
member.name <- "홍길동"
member.pwd <- "1234"

num <- 10
NUM <- 100
num; NUM

# scalar(1) vs vector(n)
name <- c("홍길동","이순신","유관순")
name

name[2]

# tensor : scalar(0), vector(1), matrix(2)

# 변수 목록 
ls()

# 3) 자료형
# - 숫자형, 문자형, 논리형

int <- 100 # 숫자형(연산, 차트)
string <- "대한민국" # '대한민국'
boolean <- TRUE # T,  FALSE(F)

# 자료형 반환 함수
mode(int)
mode(string)
mode(boolean)

# is.xxx()
is.numeric(int)
is.character(string)
is.numeric(boolean)
is.logical(boolean)

x <- c(100,90,NA,65,78) # NA : 결측치
is.na(x)

# 4) 자료형변환(CASTING)
# 1) 문자열 -> 숫자형
num <- c(10,20,30,"40")
num
mode(num) # chararcter
mean(num) # 에러 발생
plot(num)

num <- as.numeric(num) # 형변환은 as로 시작
mode(num) # numeric
mean(num)

# 2) 요인형(Factor)
# - 동일한 값을 범주로 갖는 집단변수 생성 
# ex) 성별-남(0)/여(1) -> 더미변수

gender <- c("M","F","M","F","M")
mode(gender) # character
plot(gender) # error

# 요인형 변환 : 문자열->요인형
fgender <- as.factor(gender)
mode(fgender) # numeric
fgender 
#[1] M F M F M
# Levels: F M - 수준
str(fgender) # Factor w/ 2 levels "F"(1),"M"(2) : 2 1 2 1 2
plot(fgender)

x <- c('M','F')
fgender2 <-factor(gender,levels = x)
str(fgender2) # Factor w/ 2 levels "M","F": 1 2 1 2 1

# mode vs class
# mode() : 자료형 반환
# class() : 자료구조 반환
mode(fgender) # numeric
class(fgender) # factor

# Factor형 고려사항
num <- c(4,2,4,2)
mode(num) # numeric

# 숫자형 -> 요인형
fnum <- as.factor(num)
fnum
# [1] 4 2 4 2
# Levels: 2(1) 4(2)
str(fnum) # Factor w/ 2 levels "2","4": 2 1 2 1

# 요인형 -> 숫자형
num2 <- as.numeric(fnum)
num2 # [1] 2 1 2 1 : 요인형으로 바뀐 숫자가 나옴

# 요인형 -> 문자형 -> 숫자형
snum <- as.character(fnum)
num2 <- as.numeric(snum)
num2 # 최초의 숫자 형태로 나옴

# 5. 기본함수 및 작업공간
# 1) 함수 도움말
mean(10,20,30,NA) # 평균 - 10 (잘못된 결과)
x <- c(10,20,30,NA)
mean(x,na.rm = TRUE) # NA를 제외하고 평균 계산
help(mean)
?mean

sum(x,na.rm = TRUE)

# 2) 작업공간
getwd()
setwd("C:/Rwork/data") # 경로 변경
getwd()

test <- read.csv("test.csv")
test

str(test) # 'data.frame':	402 obs. of  5 variables:
# obs. : 관측지 402(행)
# variables : 변수, 변인(열)




























