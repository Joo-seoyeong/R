# chap02_DataStructure

# 1. vector 자료구조
# - 동일 자료형을 갖는 1차원 배열구조
# - c(), seq(), rep()

# c() 함수
x <- c(1:5)
x
y <- c(1,3,5)
y

# seq()
seq(1,9,by=2) # (start,end,step) step : 증감값
seq(9,1,by=-2)

# rep()
rep(1:3, 3) #  1 2 3 1 2 3 1 2 3
rep(1:3, each=3) # 1 1 1 2 2 2 3 3 3

# 색인(index) : 자료의 위치(index)
# R index 는 1부터 시작
a <- c(1:100)
a # [1] : index / 1 : content
a[100] # 100
a[50:60]
length(a) # 100
length(a[50:60]) # 11

start = length(a)-5
end = length(a)
a[start:end] # 95 : 100

# boolean index : 특정 조건
a[a>=10 & a<=50]

# 2. Matrix 자료구조
# - 동일한 자료형을 갖는 2차원(행,열) 배열
# - 생성 함수 :  matrix(), rbind(), cbind()

# matrix()
m1 <- matrix(c(1:9), nrow=3)
m1
dim(m1) # 3 3

x1 <- 1:5 #c(1:5)
x2 <- 2:6
x1;x2

# rbind()
m2 <- rbind(x1,x2)
m2
dim(m2)

# cbind()
m3 <- cbind(x1,x2)
m3

# matrix index : obj[row,column]
m3[1,2] # 2
m3[1,] # 1행 전체
m3[,2] # 2열 전체

# box
m2[c(1:2),c(2:4)]

x <- matrix(1:9, nrow=3, ncol=3, byrow=TRUE)
x

colnames(x) <- c("one","two","three")
x

# scalar(0), vector(1), matrix(2)
# broadcast 연산

# 1) vector vs scalar
x <- 1:10
x * 0.5 # vector * scalar
# 2) vector vs matrix
x <- 1:3
y <- matrix(1:6,nrow=2)
y
dim(y)

z <- x * y
z

# apply(x,margin(행:1/열:2),fun) :처리
apply(z,1,sum) # 20 26
apply(z,2,mean) # 2.5  6.5 14.0
apply(z,2,max) # 4  9 18

# 3. array
# - 동일한 자료형을 갖는 3차원 배열구조
arr <- array(1:12, c(3,2,2))
arr
dim(arr) # 3(row) 2(col) 2(side)

arr[,,1] # 1면
arr[,,2] # 2면

# 4. data.frame
# - 행렬구조를 갖는 자료구조
# - 칼럼단위 서로 상이한 자료형을 갖는다

# vector
no <- 1:3
name <- c("홍길동","이순신","유관순")
age <- c(35,45,25)
pay <- c(200,300,150)

emp <- data.frame(NO=no,Name=name, Age=age, Pay=pay)
emp


# obj$column
epay <- emp$Pay # 벡터화
epay

mode(epay) # numeric

# 산포도 : 분산과 표준편차
var(epay)
# 양의 제곱근
sqrt(var(epay)) # 루트
sd(epay)

score <- c(90,85,83)
# 분산
var(score) # 13
# 표준편차 : 분산의 양의 제곱근
sd(score) # 3.605551
sqrt(var(score))

# 분산 = sum((x - 산술평균)^2) / n-1
avg <- mean(score) # 산술평균
avg # 86
diff <- (score-avg)^2
diff_sum <- sum(diff)
var <- diff_sum / (length(score)-1)
var # 13

sd <- sqrt(var)
sd # 3.605551

# 5. list 자료구조
# - 서로 다른 자료형(숫자,문자,논리형)과 자료구조(1,2,3차원)를 갖는 자료구조이다
# - key = value (python:dict)

# 1) key 생략 : [key =] value
list1 <- list('lee',"이순신",35, "hong","홍길동",45)
list1
# [[1]] -> default key
# [1] "lee" -> value(string)

# [[6]] -> default key
# [1] 45 -> value(int)

# key -> value 접근
list1[[1]] #-> "lee"의 key값
list1[[2]] #-> "이순신"의 key값

# index -> key:value 접근
list1[4] # ->[[4]], "hong"
# [[1]] -> key
# [1] "hong" -> value

install.packages("stringr")
library(stringr)

str <- "홍길동35이순신45"
names <- str_extract_all(str,"[가-힣]{3}")
names
# [[1]] -> key
# [1] "홍길동" "이순신" -> value

class(names) # "list"
names[[1]] # [1] "홍길동" "이순신"
names[[1]][2] # [[1]]:key, [2]:vector index

# 2) key = value
member = list(name=c("홍길순","이순신"),
              age=c(35,45),
              gender=c("여","남"))
member
# $name -> key
# [1] "홍길순" "이순신" -> value

# key -> value
member$name # "홍길순" "이순신"
member$name[2] # "이순신"
class(member) # "list"

# $ 기호
# data.frame vs list
# data.frame$column
# list$key






