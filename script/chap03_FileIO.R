#chap03_FileIO

# 1. 파일 자료 읽기
setwd("c:/Rwork/data")

# (1) read.table() : 컬럼 구분자(공백, 특수문자)

# - 칼럼명이 없는 경우
student <- read.table # header=FALSE, sep=""(컬럼의 기본 구분자는 공백)
student
# 기본 컬럼명 : v1 v2 v3 v4

# -컬럼명이 있는 경우
student1 <- read.table("student1.txt", header=TRUE,sep="")
student1
class(student1)

# - 컬럼 구분자 : 특수문자(:, ;, ::)
student2 <- read.table("student2.txt", header=TRUE,sep=";")
student2

# (2) read.csv() : 컬럼 구분자 콤마(,)
bmi <- read.csv("bmi.csv") # 문자형 -> Factor
bmi
str(bmi) # 파일에 대한 세부정보 요약
# 'data.frame':	20000 obs. of  3 variables:
# $ height: (숫자형)int  184 189 183 143 187 161 186 144 184 165 ...
# $ weight: (숫자형)int  61 56 79 40 66 52 54 57 55 76 ...
# $ label : (범주형)Factor w/ 3 levels "fat","normal",..: 3 3 2 2 2 2 3 1 3 1 ...
h <- bmi$height
mean(h) # 164.9379
w <- bmi$weight
mean(w) # 62.40995

# 범주형 빈도수 확인
table(bmi$label) 
# fat(1) normal(2)   thin(3) 
# 7425   7677        4898 

# 문자형 -> 문자형
bmi2 <- read.csv("bmi.csv",stringsAsFactors = FALSE)
str(bmi2) # $ label : chr 

# 파일 탐색기 이용
test <- read.csv(file.choose()) # test.csv
test

# (3) read.xlsx() : 패키지 설치
install.packages("xlsx")
library(xlsx)

kospi <- read.xlsx("sam_kospi.xlsx", sheetIndex = 1)
kospi
head(kospi)

# 한글 엑셀 파일 읽기 : encoding 방식
st_excel <- read.xlsx("studentexcel.xlsx", sheetIndex = 1, encoding = "UTF-8")
st_excel

# 데이터 셋 제공 사이트 
# http://www.public.iastate.edu/~hofmann/data_in_r_sortable.html - Datasets in R packages
# https://vincentarelbundock.github.io/Rdatasets/datasets.html
# https://r-dir.com/reference/datasets.html - Dataset site
# http://www.rdatamining.com/resources/data

# (4) 인터넷 파일 읽기
titanic <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/COUNT/titanic.csv")
str(titanic) # data.frame':	1316 obs. of  5 variables

dim(titanic) # 1316 5

# 성별 빈도수
table(titanic$sex)
# 생존 여부 빈도수
table(titanic$survived)

# 교차분할표 : 2개의 범주형 변수(행,열)
# 성별에 따른 생존 여부
tab <- table(titanic$sex, titanic$survived)
tab

# 막대차트
barplot(tab, col = rainbow(2), main="생존여부")

# 2. 파일 자료 저장

# 1) 화면 출력
a <- 10
b <- 20
c <- a*b
print(c)
cat('c=',c) # c= 200

# 2) 파일 저장
# read.csv <-> write.csv
# read.xlsx <-> write.xlsx

getwd()
setwd("c:/Rwork/data/output")

# (1) write.csv() : 콤마 구분자
str(titanic) # data.frame':	1316 obs. of  5 variables

# 1컬럼 제외, 따옴표 제거, 행 번호 제거
write.csv(titanic[-1],"titanic.csv",quote = FALSE, row.names = FALSE)

titan <- read.csv("titanic.csv")
head(titan)

# (2) write.xlsx() : 엑셀 파일 저장
library(xlsx)
write.xlsx(kospi,"kospi.xlsx",sheetName = "sheet1",row.names = FALSE)










































