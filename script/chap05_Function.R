# chap05_Function

# 함수 : 사용자 정의함수, 내장함수

# 1. 사용자 정의함수
# 형식)
# 함수명 <- function(인수){
#   명령문1
#   명령문2
#   return(값)
# }

# 1) 매개변수가 없는 함수
user_fun1 <- function(){
  cat("user_fun1")
}

# 함수 호출
user_fun1() # 매개변수가 없으므로 빈 괄호로 호출

# 2) 매개변수가 있는 함수
user_fun2 <- function(x,y){
  z <- x + y
  cat('z=',z)
}
user_fun2(10,20)

# 3) 반환값이 있는 함수
user_fun3 <- function(x,y){
  z <- x + y
  return(z) # 반환값
}

z=user_fun3(100,200)

cat('z=',z)

# 문) 다음과 같은 함수를 만드시오
# 조건1> 함수명 : calc
# 조건2> 인수 2개 : x,y
# 조건3> 처리문 : 사칙연산(+,-,*,/) 출력
calc <- function(x,y){
  cat("x+y=",x+y,"\n")
  cat("x-y=",x-y,"\n")
  cat("x*y=",x*y,"\n")
  cat("x/y=",x/y,"\n")
  add <- x+y
  sub <- x-y
  div <- x/y
  mul <- x*y
  #return(add,sub,div,mul) => 다중인자 반환은 허용되지 않습니다
  calc_re <- data.frame(add,sub,div,mul)
  return(calc_re)
}
#함수 호출
result <- calc(30,50)
class(result) # data.frame
result

# ex1) 결측치 자료 처리 함수
na <- function(data){
  # 1차 : NA 제거 -> 평균 출력
  print(data)
  print(mean(data,na.rm=TRUE))
  
  # 2차 : NA -> 0으로 대체
  tmp <- ifelse(is.na(data),0,data)
  print(tmp)
  print(mean(tmp))
  
  # 3차 : NA -> 평균으로 대체
  tmp <- ifelse(is.na(data),mean(data,na.rm = TRUE),data)
  print(tmp)
  print(mean(tmp))
}
data <- c(10,2,5,NA,60,NA,3)
data

# 함수 호출
na(data)
# [1] 10  2  5 NA 60 NA  3 -> data
# [1] 16 -> 제거
# [1] 11.42857 -> 0
# [1] 16 -> 평균

# ex2)특수문자 처리함수
install.packages("stringr")
library(stringr)

library(help="stringr")

string <- "홍길동35 이순신45 유관순25"
name <- str_extract(string,"[가-힣]{3}")
name # 홍길동
names <- str_extract_all(string,"[가-힣]{3}")
names  # list
# [[1]] -> key
# [1] "홍길동" "이순신" "유관순" -> value
names <- unlist(names) # list -> vector로 변환
names # [1] "홍길동" "이순신" "유관순"

string2 <- "$(124,543)%"
string2 * 2 # 에러 발생

# 1. 특수문자 제거
tmp <- str_replace_all(string2,"\\$|\\(|\\,|\\)|\\%","")
tmp
# 2. 문자열을 숫자형으로 변환
num <- as.numeric(tmp) # string을 숫자형으로 변환
num * 2 # 249086

# 특수문자 처리함수
data_pro <- function(data){
  library(stringr) # in memory
  # 1. 특수문자 제거
  tmp <- str_replace_all(data,"\\$|\\(|\\,|\\)|\\%","")
  tmp
  # 2. 문자열을 숫자형으로 변환
  num <- as.numeric(tmp) # string을 숫자형으로 변환
  num * 2
  
  return(num)
}

# dataset 
setwd("c:/Rwork/data")
stock <- read.csv("stock.csv")
str(stock) # data.frame':	6706 obs. of  69 variables

# subset : 1~15
stock_df <- stock[c(1:15)]
str(stock_df)

head(stock_df)

# 숫자(7~15) : 특수문자 제거
stock_num <- apply(stock_df[c(7:15)],2,data_pro)
stock_num

# df=문자열 컬럼 + 숫자 컬럼
new_stock <- cbind(stock_df[c(1:6)],stock_num)
head(new_stock)

# 2. 내장함수
# 1) 기본 내장함수
data <- runif(20,min=0,max=100) # 0~100사이에서 난수 20개 생성
data
min(data)
max(data)
range(data)
mean(data) # 34.77176 = sum/n
median(data) # 28.34848
(data[10]+data[11])/2 # 28.75554

sdata <- sort(data) # 오름차순 정렬
(sdata[10]+sdata[11])/2 # 28.34848

# 요약통계량
summary(data)

sum(data)
var(data) # 분산
sd(data) # 표준편차

# 제곱/제곱근
4^2
sqrt(16)

# 정렬:sort()/order()
data(iris) # 붓꽃 데이터 
str(iris)
# 'data.frame':	150 obs. of  5 variables:
# $ Sepal.Length(꽃받침 길이): num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
# $ Sepal.Width(꽃받침 넓이) : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
# $ Petal.Length(꽃잎의 길이): num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
# $ Petal.Width(꽃잎의 넓이) : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
# $ Species(꽃의 종): Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
# 1~4 컬럼 : 연속형(숫자 연산 가능) / 5 컬럼 : 범주형(문자형) -> 3개의 범주

head(iris)
# 컬럼 단위 정렬
sort(iris$Sepal.Length) # 오름차순 정렬(내용)
sort(iris$Sepal.Length, decreasing=TRUE) # 내림차순 정렬

# 행 단위 정렬
dim(iris) # 150(row) 5(col)
idx <- order(iris$Sepal.Length) # 오름차순 정렬(index)
iris_df <- iris[idx,]
head(iris_df)

summary(iris)

# 2) 로그, 지수
# (1) 일반로그 : log10(x) -> x는 10(밑수)의 몇 제곱?
log10(10) # 1 -> 10^1 = 10
log10(100) # 2 -> 10^2 = 100

# (2) 자연로그 : log(x) -> x는 e(밑수)의 몇 제곱?
log(10) # 2.302585 -> e^2.302585 = 10

e <- exp(1) # e = 2.718282
e^2.302585 # 9.999999

# (3) 지수 : exp(x) -> e^x
exp(2) # 7.389056
e^2 # 7.389056

# 로그 vs 지수
x <- c(0.12, 1, 12, 999, 99999)
x
exp(x) #  1.127497e+00 2.718282e+00 1.627548e+05 Inf Inf
log(x) # -2.120264  0.000000  2.484907  6.906755  11.512915
range(log(x)) # -2.120264 11.512915

# 로그 함수 : 정규화(편향 제거 목적) : x 증가 -> y 완만
# 지수 함수 : 활성함수(sigmoid, softmax) : x 증가 -> y 급격


# 3) 난수 생성과 확률분포

# 1. 정규분포를 따르는 실수 난수 생성
# 형식) rnorm(n,mean,sd)
?rnorm
n <- 1000 # 중심 극한의 정리 
r <- rnorm(n,mean=0, sd=1)
r
# 대칭성 확인
hist(r)

# 2. 균등분포를 따르는 실수 난수 생성
r2 <- runif(n,min=0,max=1) # 0~1사이의 난수 생성
hist(r2)

# 3. 이항분포를 따르는 정수 난수 생성
# rbinom(n,size,prob)
# size : sample size / prob : sample size가 나올 수 있는 확률
n <- 10
r3 <- rbinom(n,size=1,prob=0.5) # 1/2 
r3 # 1 1 0 0 0 0 0 1 0 1
r3 <- rbinom(n,size=1,prob=0.25) # 1/4
r3 # 1 0 0 0 0 0 1 0 0 1
r3 <- rbinom(n,size=3,prob=0.25)
r3 # 1 0 0 0 0 0 0 0 1 0

# 4. 종자값(seed)
set.seed(123)
r <- rnorm(10)
r
