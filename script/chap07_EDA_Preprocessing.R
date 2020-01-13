# chap07_EDA_Preprocessing

# 실습 데이터 파일 가져오기
setwd("c:/Rwork/data")
dataset <- read.csv("dataset.csv")
str(dataset)
# 'data.frame':	300 obs. of  7 variables:
# $ resident: int  1 2 NA 4 5 3 2 5 NA 2 ...
# $ gender  : int  1 1 1 2 1 1 2 1 1 1 ...
# $ job     : int  1 2 2 NA 3 2 1 2 1 2 ...
# $ age(비율)     : int  26 54 41 45 62 57 36 NA 56 37 ...
# $ position: int  2 5 4 4 5 NA 3 3 5 3 ...
# $ price(비율)   : num  5.1 4.2 4.7 3.5 5 5.4 4.1 675 4.4 4.9 ...
# $ survey(등간)  : int  1 2 4 2 1 2 4 4 3 3 ...

# 1. 결측치(NA) 처리

# 1) 결측치 확인
summary(dataset) # price : NA's :30

# 2) 컬럼 기준 결측치 제거 : subset()
dataset2 <- subset(dataset, !is.na(price)) # (dataset, 조건식)
dim(dataset2) # 270 7
head(dataset2)

# 3) 전체 컬럼 기준 결측치 제거 : na.omit()
dataset2 <- na.omit(dataset)
dim(dataset2) # 209 7
head(dataset2)

# 4) 결측치 처리(0으로 대체)
dataset$price2 <- ifelse(is.na(dataset$price),0,dataset$price)
head(dataset,30)
dataset[c("price","price2")]

# 5) 결측치 처리(평균으로 대체)
avg <- mean(dataset$price, na.rm = T)
avg # 8.751481
dataset$price3 <- ifelse(is.na(dataset$price),avg,dataset$price)
dataset[c("price","price2","price3")] 

# 6) 통계적 방법 : 고객 유형별 NA 처리
# type : 1. 우수, 2.보통, 3.저조
# 1. 우수 : 8.75 * 1.5
# 2. 보통 : 8.75 
# 3. 저조 : 8.75 * 0.5
dim(dataset) # 300 9
type <- rep(1:3,100)
type
# 고객의 유형을 컬럼으로 추가
dataset$type <- type
head(dataset)


price4 <- 0 # 통계적 방법
for(i in 1:nrow(dataset)){ # i는 index역할 => 300번 반복
  if(is.na(dataset$price[i])){ # NA
    if(dataset$type[i] == 1){ # 우수 고객
      price4[i] = avg * 1.5
    }else if(dataset$type[i] == 2){ # 보통 고객
      price4[i] = avg
    }else{ # 저조 고객
      price4[i] = avg * 0.5
    }
  }else{ # NOT NA
    price4[i] <- dataset$price[i]
  }
}


length(price4) # 300

# 컬럼 추가
dataset$price4 <- price4

dataset[c("price","price2","price3","price4")]

# 2. 이상치(극단치) 발견과 정제
# - 정상 범주에서 크게 벗어난 값
# - 분석 결과 왜곡시킴

# (1) 범주형(명목, 서열) 극단치 처리
gender <- dataset$gender
gender

# 빈도수 확인
table(gender)
# 0   1   2   5 -> 범주
# 2 173 124   1 -> 빈도
pie(table(gender))

# 이상치 정제
dataset <- subset(dataset, gender==1 | gender==2)
pie(table(dataset$gender))

# 2) 비율척도 이상치 처리

price <- dataset$price # 구매 금액액
plot(price)

# 이상치 발견
boxplot(price)$stats

# 이상치 정제
dataset2 <- subset(dataset,dataset$price >= 2.1 & dataset$price <= 7.9)
plot(dataset2$price)

# age 변수 이상치 처리
summary(dataset2$age)
dataset2 <- subset(dataset2, age >= 20 & age <= 69)
plot(dataset2$age)

# 3. 코딩 변경 : 최초 코딩 내용을 변경
# - 데이터 가독성, 척도 변경
# 1) 데이터 가독성
table(dataset2$resident)
# 1     2   3   4   5 
# 102  46  22  13  34

dataset2$resident2[dataset2$resident==1] <- "1.서울시"
dataset2$resident2[dataset2$resident==2] <- "2.인천시"
dataset2$resident2[dataset2$resident==3] <- "3.대전시"
dataset2$resident2[dataset2$resident==4] <- "4.대구시"
dataset2$resident2[dataset2$resident==5] <- "5.울산시"

# 2) 척도 변경(연속형 -> 범주형)
dataset2$age2[dataset2$age <= 30] <- "청년층"
dataset2$age2[dataset2$age > 30 & dataset2$age <= 55] <- "중년층"
dataset2$age2[dataset2$age > 55] <- "장년층"

dataset2[c("age","age2")]

# 4. 탐색적 분석을 위한 시각화 

setwd("c:/Rwork/data")
new_data <- read.csv("new_data.csv", header=TRUE)
str(new_data) # data.frame':	231 obs. of  15 variables

# 1) 명목척도(범주/서열) vs 명목척도(범주/서열) 
# - 거주지역과 성별 칼럼 시각화 
resident_gender <- table(new_data$resident2, new_data$gender2)
resident_gender
gender_resident <- table(new_data$gender2, new_data$resident2)
gender_resident

# 성별에 따른 거주지역 분포 현황 
barplot(resident_gender, beside=T, horiz=T,
        col = rainbow(5),
        legend = row.names(resident_gender),
        main = '성별에 따른 거주지역 분포 현황') 
# row.names(resident_gender) # 행 이름 

# 거주지역에 따른 성별 분포 현황 
barplot(gender_resident, beside=T, 
        col=rep(c(2, 4),5), horiz=T,
        legend=c("남자","여자"),
        main = '거주지역별 성별 분포 현황')  

# 2) 비율척도(연속) vs 명목척도(범주/서열)
# - 나이와 직업유형에 따른 시각화 
install.packages("lattice")  # chap08
library(lattice)

# 직업유형에 따른 나이 분포 현황   
densityplot( ~ age, data=new_data, groups = job2,
             plot.points=T, auto.key = T)
# plot.points=T : 밀도, auto.key = T : 범례 

# 3) 비율(연속) vs 명목(범주/서열) vs 명목(범주/서열)
# - 구매비용(연속):x칼럼 , 성별(명목):조건, 직급(서열):그룹   

# (1) 성별에 따른 직급별 구매비용 분석  
densityplot(~ price | factor(gender2), data=new_data, 
            groups = position2, plot.points=T, auto.key = T) 
# | 격자 : 범주형(성별), groups(그룹) : 직급 

# (2) 직급에 따른 성별 구매비용 분석  
densityplot(~ price | factor(position2), data=new_data, 
            groups = gender2, plot.points=T, auto.key = T) 
# 조건 : 직급(격자), 그룹 : 성별

# 4) 연속형 변수간의 상관분석
str(new_data)
# 결측치 제거
new_data2 <- na.omit(new_data)
# vector.


age <- new_data2$age
price <- new_data2$price
# DF
df <- data.frame(age,price)
cor(df) # 0.0881251

plot(df$age,df$price) # (y~x)














