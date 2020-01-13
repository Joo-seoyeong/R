# chap13_1_DecisionTree

# 관련 패키지 설치치
install.packages("rpart")
library(rpart)

# tree 시각화 패키지
install.packages("rpart.plot")
library(rpart.plot)

# 1. dataset(train/test) : iris
idx <- sample(nrow(iris),nrow(iris)*0.7)
train <- iris[idx,]
test <- iris[-idx,]
names(iris)
# 2. 분류모델
model <- rpart(Species~., data=train)
model

# 분류모델 시각화
rpart.plot(model)
# [중요변수] 가장 주요한 변수는? "Petal.Length"

# 3. 모델 평가
y_pred <- predict(model,test) # 비율 예측치
y_pred

y_pred <- predict(model, test, type="class") # 클래스 예측치
y_pred

y_true <- test$Species

# 교차분할표(confusion matrix)
table(y_true, y_pred)
#            y_pred
# y_true     setosa versicolor virginica
# setosa     15     0          0
# versicolor 0      16         1
# virginica  0      2          11

acc <- (15+16+11)/ nrow(test)
acc # 0.9333333 (분류정확도)

#################################
######## Titanic 분류분석########
#################################
setwd("c:/Rwork/data")
titanic3 <- read.csv("titanic3.csv")
str(titanic3) # 'data.frame':	1309 obs. of  14 variables
# titanic3.csv 변수 설명
# 'data.frame': 1309 obs. of 14 variables:
# 1.pclass : 1, 2, 3등석 정보를 각각 1, 2, 3으로 저장
# 2.survived : 생존 여부. survived(생존=1), dead(사망=0)
# 3.name : 이름(제외)
# 4.sex : 성별. female(여성), male(남성)
# 5.age : 나이
# 6.sibsp : 함께 탑승한 형제 또는 배우자의 수
# 7.parch : 함께 탑승한 부모 또는 자녀의 수
# 8.ticket : 티켓 번호(제외)
# 9.fare : 티켓 요금
# 10.cabin : 선실 번호(제외)
# 11.embarked : 탑승한 곳. C(Cherbourg), Q(Queenstown), S(Southampton)
# 12.boat : (제외)Factor w/ 28 levels "","1","10","11",..: 13 4 1 1 1 14 3 1 28 1 ...
# 13.body : (제외)int  NA NA NA 135 NA NA NA NA NA 22 ...
# 14.home.dest: (제외)

# int -> Factor(범주형)
titanic3$survived <- factor(titanic3$survived, levels=c(0,1))
table(titanic3$survived)
# 0   1 
# 809 500

809 / 1309 # 사망비율=0.618029(62%)

# subset 생성 : 칼럼 제외
titanic <- titanic3[-c(3,8,10,12,13,14)]
str(titanic) # 'data.frame':	1309 obs. of  8 variables
# $ survived: Factor w/ 2 levels "0","1"

# train/test set
idx <- sample(nrow(titanic), nrow(titanic)*0.8)
train <- titanic[idx,]
test <- titanic[-idx,]

model <- rpart(survived~., data=train)
model

rpart.plot(model)

y_pred <- predict(model, test, type="class")
y_true <- test$survived

table(y_true, y_pred)
#        y_pred
# y_true 0   1
#      0 139 21
#      1  36 66

acc <- (139+66)/nrow(test)
acc # 0.7824427

table(test$survived) # 실제 생존여부 관측치
# 0   1 
# 160 102

# 정확률 :
precision <- 66/(21+66)
precision # 0.7586207

# 재현율 : Yes -> Yes
recall<- 66/(36+66)
recall # 0.6470588

# f1 score 
f1_score <- 2 * (( precision*recall) / (precision+recall))
f1_score # 0.6984127

























