# chap04_Control

# 제어문 : 조건문과 반복문

# <실습> 산술연산자 
num1 <- 100 # 피연산자1
num2 <- 20  # 피연산자2
result <- num1 + num2 # 덧셈
result # 120
result <- num1 - num2 # 뺄셈
result # 80
result <- num1 * num2 # 곱셈
result # 2000
result <- num1 / num2 # 나눗셈
result # 5

result <- num1 %% num2 # 나머지 계산
result # 0

result <- num1^2 # 제곱 계산(num1 ** 2)
result # 10000
result <- num1^num2 # 100의 20승
result # 1e+40 -> 1 * 10의 40승과 동일한 결과


# <실습> 관계연산자 
# (1) 동등비교 
boolean <- num1 == num2 # 두 변수의 값이 같은지 비교
boolean # FALSE
boolean <- num1 != num2 # 두 변수의 값이 다른지 비교
boolean # TRUE

# (2) 크기비교 
boolean <- num1 > num2 # num1값이 큰지 비교
boolean # TRUE
boolean <- num1 >= num2 # num1값이 크거나 같은지 비교 
boolean # TRUE
boolean <- num1 < num2 # num2 이 큰지 비교
boolean # FALSE
boolean <- num1 <= num2 # num2 이 크거나 같은지 비교
boolean # FALSE

# <실습> 논리연산자(and, or, not, xor)
logical <- num1 >= 50 & num2 <=10 # 두 관계식이 같은지 판단 
logical # FALSE
logical <- num1 >= 50 | num2 <=10 # 두 관계식 중 하나라도 같은지 판단
logical # TRUE

logical <- num1 >= 50 # 관계식 판단
logical # TRUE
logical <- !(num1 >= 50) # 괄호 안의 관계식 판단 결과에 대한 부정
logical # FALSE

x <- TRUE; y <- FALSE
xor(x,y) # [1] TRUE
x <- TRUE; y <- TRUE
xor(x,y) # FALSE

# 1. 조건문
# (1) if("조건식"){}
x <- 10
y <- 5
z <- x*y
z
if(z >= 50){ # TRUE인 경우
  print("z는 50이상이다.")
}else{ # FALSE인 경우
  print("z는 50미만이다.")
}

# 학점 구하기
score <- scan() # 키보드 입력
score

grade <- "" # 등급 변수 선언
if(score >= 90){
  grade <- "A학점"
}else if(score>=80){ # 89~80
  grade <- "B학점"
}else if(score>=70){ # 79~70
  grade <- "C학점"
}else{# 69점 미만
  grade <- "F학점"
}
cat("점수:", score,"등급:", grade) # 점수: 85 등급: B학점

# 배수 구하기
10 / 2 # 5
10 %% 2 # 0
10 %% 3 # 1 
# 문) 키보드 입력 숫자가 5의 배수인지 판별하시오
input <- scan()

if(input%%5==0){
  cat(input,"은 5의 배수입니다")  
}else{
  cat(input,"은 5의 배수가 아닙니다")
}

# 2) ifelse() : if+else+roof
# 형식) ifelse(조건식,참,거짓) - 3항 연산자
# vector(n) -> 처리 -> vector(n)

score <- c(90,65,NA,80,59)
score
sum(score) # NA
sum(score, na.rm = TRUE) # 294

# 파생 변수
result <- ifelse(score>=70,"합격","불합격")
result

# 결측치 처리 : NA -> 0
result2 <- ifelse(is.na(score),0,score)
result2 # 90 65  0 80 59
sum(result2) # 294

# 3) which() : 조건에 해당하는 위치(index)를 반환
x <- seq(1,10,3)
x # 1 4 7 10

which(x == 7) # 3

# 행렬구조 위치
emp <- read.csv("c:/Rwork/data/emp.csv")
emp
#class(emp) # data.frame -> 행렬구조
#emp[1,2] <- "유관순"

idx <- which(emp$name == "유관순")
idx

# subset example
emp_sub <- emp[idx, ]
emp_sub

# 변수 선택 example
library("MASS")
data("Boston") # Boston 주택가격
str(Boston) # data.frame':	506 obs. of  14 variables
# 1 ~ 13 : x변수(독립변수)
# medv : y변수(종속변수) - 주택 가격

# 컬럼 가져오기
cols <- names(Boston)
cols # [1] crim [14] medv

idx <- which(cols == "medv")
idx

y <- Boston[,idx]
x <- Boston[,-idx] # 14 컬럼을 제외한 나머지 컬럼

y # vector
dim(x) # 506 13 : data.frame

# 2. 반복문
# 1) for(변수 in 값){반복문}
x <- rnorm(n=10,mean=0 , sd=1)
x
length(x) # 10

y <- 0 # x^2
idx <- 1 # index
for(v in x){ # 10회 반복
  cat("v=",v, "\n")  
  y[idx] <- v^2 # vector에 저장
  idx <- idx + 1 # 카운터
}

y

i <- 1:10
for(v in i){ # 10회 반복 
  #print(v)
  # 짝수만 출력
  if(v %% 2 == 0)
    print(v) 
}

# 키보드 입력 -> 홀수만 출력
num <- scan()
num # 6개의 값을 가진 vector
for(i in num){
  if(i %% 2 == 1)
  print(i)
}

# 1~100까지 홀수의 합과 짝수의 합 출력하기
even <- 0 # 짝수의 합
odd <- 0 # 홀수의 합
num <- 1:100
for(i in num){
  if(i%%2==0){
    even <- even+i
  }else{
    odd <- odd+i
  }        
}
cat("짝수 합=",even,"홀수 합=",odd)

setwd("c:/Rwork/data")
st <- read.table("student.txt")
st
colnames(st) <- c("sid","name","height","weight")

# if+else+for
height2 <- ifelse(st$height>=180,"high","low")
weight2 <- ifelse(st$weight>=65,"high","low")

# 파생변수 추가
st$height2 <- height2
st$weight2 <- weight2

st

# (2) while(조건식){반복문}
i = 0 # 초기화
while(i<10){
  print(i)
  i <- i+1 #카운터 i += 1(x)
}

# while + index : x의 각 변량에 제곱
x <- c(2,5,8,6,9)
x

y <- 0 # y = x^2
i <- 0 # 카운터 변수(index)

while(i<length(x)){ # 0 < 5
  i <- i + 1 # 카운터
  cat("y=",x[i]^2,"\n")
  y[i] <- x[i]^2
}
y # 4 25 64 36 81

# while() -> for()
i <- 0
y <- 0
for(v in x){
  i <- i+1
  y[i] <- v^2
}
y # 4 25 64 36 81















