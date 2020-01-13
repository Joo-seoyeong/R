# chap10_Ttest_ANOVA

# 1-1. 단일집단 비율차이 검정
# - 비모수 검정

# 1) data 가져오기
setwd("c:/Rwork/data")
data <- read.csv("one_sample.csv")
head(data)

# 2) 빈도/통계량 확인
x <- data$survey
summary(x)
table(x)
# 0(불만) 1(만족) 
# 14      136    -> 150

# 3) 가설 검정
# binom.test(성공횟수,시행횟수,p=확률)
binom.test(14,150,p=0.2) # 기존 불만족율 기준 검증
# p-value = 0.0006735 -> 귀무가설 기각
binom.test(14,150,p=0.2,alternative="two.sided",conf.level = 0.95) # 양측검정, 신뢰수준 95%
# p-value = 0.0006735 -> 2014년과 2015년의 불만율에 차이가 있다
?binom.test

# 대립가설 채택:방향성이 있는 가설
# 2014(20%) < 2015(14)
binom.test(14,150,p=0.2,alternative = "greater",conf.level = 0.95)
# p-value = 0.9999 -> 귀무가설 기각할 수 없다. 대립가설 기각
# 2014(20%) > 2015(14)
binom.test(14,150,p=0.2,alternative = "less",conf.level = 0.95)
# p-value = 0.0003179 -> 귀무가설 기각. 대립가설 채택 

# 1-2. 단일집단 평균 차이 검정
# 1) data 가져오기
data <- read.csv("one_sample.csv")
head(data)

time <- data$time
length(time) # 150

# 2) 전처리
mean(time,na.rm = T) # 5.556881

x <- na.omit(time) # 결측치 제거
x
length(x) # 109

# 3) 전제조건:정규성 검정
shapiro.test(x) # p-value = 0.7242 > 0.05 : 귀무가설 채택->정규성을 만족

# 4) 단일집단 평균차이 검정
t.test(x,mu=5.2) # 양측검정
# t = 3.9461, df = 108, p-value = 0.0001417
?t.test
# p-value = 0.0001417 < 0.05 : 귀무가설 기각
# t : -1.96~+1.96(95%) : 귀무가설 채택역

# 대립가설:단측검정(방향성)
# A회사 > 국내
t.test(x,mu=5.2,alternative = "greater")
# t = 3.9461, df = 108, p-value = 7.083e-05 < 0.05 -> 귀무가설 기각
# A회사가 국내보다 노트북 평균 사용 시간이 길다

# A회사 < 국내
t.test(x,mu=5.2,alternative = "less")
# t = 3.9461, df = 108, p-value = 0.9999 > 0.05 -> 귀무가설 기각x
# A회사가 국내보다 노트북 평균 사용 시간이 길지 않다

# 2-1. 두 집단 비율차이 검정
# 1. 실습데이터 가져오기
data <- read.csv("two_sample.csv", header=TRUE)
data
head(data) # 변수명 확인

# 2. 두 집단 subset 작성
data$method # 1, 2 -> 노이즈 없음
data$survey # 1(만족), 0(불만족)
# 데이터 정체/전처리
x<- data$method # 교육방법(1, 2) -> 노이즈 없음
y<- data$survey # 만족도(1: 만족, 0:불만족)
table(x) # 1:150 / 2:150
table(y) # 0:55 / 1:245

table(x,y)
#    y
# x  0   1
# 1  40  110 -> 집단1(ppt)
# 2  15  135 -> 집단2(실습)

# 3) 두 집단 비율차이검정 - prop.test()
help(prop.test) # prop.test(x,n,p, alternative, conf.level, correct)

# 양측검정
prop.test(c(110,135),c(150,150)) # 방법A 만족도와 방법B 만족도 차이 검정
# p-value = 0.0003422

#sample estimates: 집단 간 비율
# prop 1 prop 2
#0.7333333 0.9000000

prop.test(c(110,135),c(150,150), alternative="two.sided", conf.level=0.95)
# 해설) p-value = 0.0003422 - 두 집단간의 만족도에 차이가 있다.

# 대립가설:단측검정 (방법1>방법2)
prop.test(c(110,135),c(150,150), alternative="greater", conf.level=0.95)
# p-value = 0.9998 => 귀무가설 기각x
 
# 대립가설:단측검정 (방법1<방법2)
prop.test(c(110,135),c(150,150), alternative="less", conf.level=0.95)
# p-value = 0.0001711 => 귀무가설 기각

# 2-2. 두 집단 평균차이 검정
# 1) 실습파일 가져오기
data <- read.csv("two_sample.csv", header=TRUE)
data
print(data)
head(data) #4개 변수 확인
summary(data) # score - NA's : 73개

# 2) 두 집단 subset 작성(데이터 정제,전처리)
result <- subset(data, !is.na(score), c(method, score))
# c(method, score) : data의 전체 변수 중 두 변수만 추출
# !is.na(score) : na가 아닌 것만 추출
# 위에서 정제된 데이터를 대상으로 subset 생성
result # 방법1과 방법2 혼합됨
length(result$score) # 227

# 데이터 분리
# 1) 교육방법 별로 분리
a <- subset(result,method==1)
b <- subset(result,method==2)

# 2) 교육방법에서 점수 추출
a1 <- a$score # 방법1의 실기점수
b1 <- b$score # 방법2의 실기점수

# 기술통계량 -> 평균값 적용 -> 정규성 검정 필요
length(a1) # 109
length(b1) # 118

# 3) 분포모양 검정 : 두 집단의 분포모양 일치 여부 검정
# 귀무가설 : 두 집단 간 분포의 모양이 동질적이다.
# 두 집단간 동질성 비교(분포모양 분석)
var.test(a1, b1) # p-value = 0.3002 -> 차이가 없다.
# 동질성 분포 : t.test()
# 비동질성 분포 : wilcox.test()

# 4) 가설검정 – 두 집단 평균 차이검정
t.test(a1, b1)
t.test(a1, b1, alter="two.sided", conf.int=TRUE, conf.level=0.95)
# p-value = 0.0411 - 두 집단간 평균에 차이가 있다.

# 대립가설 : a1 > b1
t.test(a1, b1, alter="greater", conf.int=TRUE, conf.level=0.95)
# p-value = 0.9794 : a1을 기준으로 비교 -> a1이 b1보다 크지 않다.

# 대립가설 : a1 < b1
t.test(a1, b1, alter="less", conf.int=TRUE, conf.level=0.95)
# p-value = 0.02055 : a1이 b1보다 작다.

# 3. 분산분석
# 두 집단 이상 평균차이 검정(집단 분산 차이 검정)
# 일원배치 분산분석 : 독립변수(X), 종속변수(Y)
# cf) 이원배치 분산분석 : y ~ x1 + x2

# aov(y ~ x, data = dataset)

# 독립변수 : 집단변수(범주형)
# 종속변수 : 연속형 변수(비율,등간척도)
# ex) 쇼핑몰 고객의 연령대별(20,30,40,50대) 구매금액(연속형)에 차이가 있는지?
# 독립변수 : 연령대 / 종속변수 : 구매금액

# 귀무가설 : 집단별 평균(분산)의 차이가 없다
# 대립가설 : 적어도 한 집단에 평균 차이가 있다

#########iris dataset###########
# 귀무가설 : 꽃이 종별로 꽃받침의 넓이의 차이가 없다
# 1. 변수 선택
str(iris)
x <- iris$Species # 집단변수
y <- iris$Sepal.Width # 연속형

# 2. data 전처리
# 3. 동질성 검정
bartlett.test(Sepal.Width ~ Species, data=iris) 
# p-value = 0.3515 > 0.05 => 동질성 가정

# 4. 분산분석 : aov(y~x,data)
model <- aov(Sepal.Width ~ Species, data=iris)
model

# 5. 분산분석 해석
summary(model)
#              Df Sum Sq Mean Sq F value Pr(>F)    
# Species       2  11.35   5.672   49.16 <2e-16 ***
# Residuals   147  16.96   0.115           

# 귀무가설 기각 -> 적어도 한 집단 이상의 평균 차이가 있다

# 6. 사후 검정 : 각 집단별 차이를 상세히 분석
TukeyHSD(model)
#                       diff   lwr
# versicolor-setosa    -0.658 -0.81885528
# virginica-setosa     -0.454 -0.61485528
# virginica-versicolor  0.204  0.04314472
# p-value : 집단 간 평균 차이 유무 해설
# diff : 평균 차이의 정도(절댓값이 클수록 평균 차이가 심하다)

plot(TukeyHSD(model))
# 신뢰구간 : 집단 간 평균 차이 유무 해설 (신뢰구간이 0을 지나지 않으면 평균 차이가 있다)

# 통계검정 : 각 집단의 평균 차이가 있는지 없는지
library(dplyr) # dataset %>% function
iris %>% group_by(Species) %>% summarise(avg=mean(Sepal.Width))
# Species       avg
# 1 setosa      3.43
# 2 versicolor  2.77
# 3 virginica   2.97
2.77-3.43 # verisicolor-setosa=-0.66
2.97 - 2.77 # virginica-versicolor=0.2

##############비모수 검정#############
# 1. 변수 선택
names(iris)
x <- iris$Species
y <- iris$Sepal.Length

# 2. 동질성 검정
bartlett.test(Sepal.Length~Species, data=iris)
# p-value = 0.0003345 : 비모수 검정 수행

# 3. 분산분석(비모수 검정) : 평균 -> 중위수
kruskal.test(Sepal.Length~Species, data=iris)
# Kruskal-Wallis chi-squared = 96.937, df = 2, p-value < 2.2e-16 : 귀무가설 기각->세 집단별 중위수에 차이가 있다

# 4. 사후검정 : 집단별 중위수 비교
library(dplyr)
iris %>% group_by(Species) %>% summarise(med=median(Sepal.Length))
# Species      med
# 1 setosa     5  
# 2 versicolor 5.9
# 3 virginica  6.5

##############quakes###################
# 1. 전처리
str(quakes)
# 'data.frame':	1000 obs. of  5 variables:
# $ lat(위도): num  -20.4 -20.6 -26 -18 -20.4 ...
# $ long(경로): num  182 181 184 182 182 ...
# $ depth(깊이): int  562 650 42 626 649 195 82 194 211 622 ...
# $ mag(규모): num  4.8 4.2 5.4 4.1 4 4 4.8 4.4 4.7 4.3 ...
# $ stations(관측소): int  41 15 43 19 11 12 43 15 35 19 ...

y <- quakes$mag # 연속형 변수
x <- quakes$depth # 집단 변수(연속형 -> 범주형)

range(quakes$depth) # 40 680
680-40
div <- round(640/3)
div # 213

# 코딩 변경(연속형->범주형)
quakes$depth2[quakes$depth<= (40 + div)] <- "row"
quakes$depth2[quakes$depth >= (40+div)  & quakes$depth <= (680-div)]<- "mid"
quakes$depth2[quakes$depth > (680-div)] <- "high"

x <- quakes$depth2 # 집단 변수
table(quakes$depth2)
# high  mid  row 
# 366  126  508 

# 2. 동질성 검정
bartlett.test(y~x) # p-value=0.1554 => 동질성 가정 -> 모수 검정

# 3. 분산분석(모수 검정)
a<- aov(y~x)
a
#                   x       Residuals
# Sum of Squares    9.61277 152.45107
# Deg. of Freedom   2       997

summary(a)
#             Df  Sum Sq Mean Sq F value   Pr(>F)    
# x           2   9.61   4.806   31.43 5.78e-14 ***
# Residuals   997 152.45 0.153
# p-value < 0.05이므로 귀무가설 기각 : 매우 유의미한 수준에서 적어도 한 집단에서 집단 간 차이를 보인다 

# 4. 사후검정
TukeyHSD(a)
#           diff        lwr       upr        p adj
# mid-high -0.07543586 -0.1702399 0.01936818 0.1486744 : 평균에 차이가 없다
# row-high  0.17127705  0.1083477 0.23420643 0.0000000 : 평균 차이가 있다
# row-mid   0.24671291  0.1553652 0.33806060 0.0000000 : 평균 차이가 있다

plot(TukeyHSD(a))
# 중간(mid)과 깊은(high) 수심은 평균에 차이가 없다
# 낮은(low) 수심이 깊은(high) 수심에 비해서 지진의 강도에 차이가 잇다



