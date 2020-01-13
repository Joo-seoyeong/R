# chap12_2_LogisticRegression

###############################################
# 15_2. 로지스틱 회귀분석(Logistic Regression) 
###############################################

# 목적 : 일반 회귀분석과 동일하게 종속변수와 독립변수 간의 관계를 나타내어 
# 향후 예측 모델을 생성하는데 있다.

# 차이점 : 종속변수가 범주형 데이터를 대상으로 하며 입력 데이터가 주어졌을 때
# 해당 데이터의결과가 특정 분류로 나눠지기 때문에 분류분석 방법으로 분류된다.
# 유형 : 이항형(종속변수가 2개 범주-Yes/No), 다항형(종속변수가 3개 이상 범주-iris 꽃 종류)
# 다항형 로지스틱 회귀분석 : nnet, rpart 패키지 이용 
# a : 0.6,  b:0.3,  c:0.1 -> a 분류 

# 분야 : 의료, 통신, 기타 데이터마이닝

# 선형회귀분석 vs 로지스틱 회귀분석 
# 1. 로지스틱 회귀분석 결과는 0과 1로 나타난다.(이항형)
# 2. 정규분포 대신에 이항분포를 따른다.
# 3. 로직스틱 모형 적용 : 변수[-무한대, +무한대] -> 변수[0,1]사이에 있도록 하는 모형 
#    -> 로짓변환 : 출력범위를 [0,1]로 조정
# 4. 종속변수가 2개 이상인 경우 더미변수(dummy variable)로 변환하여 0과 1를 갖도록한다.
#    예) 혈액형 AB인 경우 -> [1,0,0,0] AB(1) -> A,B,O(0)

# 로짓변환 vs sigmoid function
# 1) 로짓변환 : 오즈비에 log(자연로그)함수 적용
p = 0.5 # 성공확률
odds_ratio <- p / (1-p)
logit1 <- log(odds_ratio) # 0
logit1

p = 1 # 성공확률
odds_ratio <- p / (1-p)
logit2 <- log(odds_ratio) # 양의 무한대
logit2

p = 0 # 성공확률
odds_ratio <- p / (1-p)
logit3 <- log(odds_ratio) # 음의 무한대
logit3
# [정리] p=0.5 : 0, p>0.5 : 양의 무한대, p<0.5 : 음의 무한대

# 2) sigmoid function
sig1 <- 1 / (1+exp(-logit1))
sig1 # 0.5

sig2 <- 1 / (1+exp(-logit2))
sig2 # 1

sig3 <- 1 / (1+exp(-logit3))
sig3 # 0
# [정리] logit=0 : 0.5, logit=Inf : 1, logit=-Inf : 0
# 값의 범위 : 0~1 확률값(cut off=0.5) -> 이항분류 적합합

# 단계1. 데이터 가져오기
weather = read.csv("weather.csv", stringsAsFactors = F) 
dim(weather)  # 366  15
head(weather)
str(weather) # data.frame:366 obs. of  15 variables

# chr 칼럼, Date, RainToday 칼럼 제거 
weather_df <- weather[, c(-1, -6, -8, -14)]
str(weather_df) # 'data.frame':	366 obs. of  11 variables

# RainTomorrow 칼럼 -> 로지스틱 회귀분석 결과(0,1)에 맞게 더미변수 생성      
weather_df$RainTomorrow[weather_df$RainTomorrow=='Yes'] <- 1
weather_df$RainTomorrow[weather_df$RainTomorrow=='No'] <- 0
weather_df$RainTomorrow <- as.numeric(weather_df$RainTomorrow) # 숫자로 형변환
head(weather_df)

#  단계2.  데이터 셈플링
idx <- sample(1:nrow(weather_df), nrow(weather_df)*0.7)
train <- weather_df[idx, ]
test <- weather_df[-idx, ]

dim(train)
dim(test)

#  단계3.  로지스틱  회귀모델 생성 : 학습데이터 
weater_model <- glm(RainTomorrow ~ ., data = train, family = 'binomial') # 11개의 독립변수 / family=binomial : y의 결과가 이항
weater_model 
summary(weater_model) # x변수의 유의성 검정 결과만 나타남  

# 단계4. 로지스틱  회귀모델 예측치 생성 : 검정데이터 
# newdata=test : 새로운 데이터 셋, type="response" : 0~1 확률값으로 예측 
pred <- predict(weater_model, newdata=test, type="response")  
pred 
range(pred, na.rm = TRUE) # 0.002393567 ~ 0.987685088
summary(pred)
str(pred) # Named num [1:110] : 벡터 구조

# cut off = 0.5 적용
cpred <- ifelse(pred >= 0.5,1,0) # 최종 모델에서 예측한 예측치
cpred
y_true <- test$RainTomorrow # 정답(0,1)
y_true
# 교차분할표(confusion matrix)
t <- table(y_true, cpred)
#        cpred
# y_true 0  1
#     0  85 9 = 94(no)
#     1  7  6 = 13(yes)

# 모델 평가 : 분류정확도
acc <- (85+6)/(85+9+7+6)
cat('accuracy = ', acc) # accuracy =  0.8504673

(9+7) / sum(t) # 0.1495327
# 특이도 : NO -> NO 
acc_no <- 85 / 94 # 0.9042553
# 재현율(민감도) : YES -> YES
recall <- 6 / 13 # 0.4615385
recall
# 정확률 : model(yes) -> yes
precision <- 6/17
precision # 0.3529412

# F1 Score : no != yes(불균형)
f1_score <- 2 * ((precision * recall) / (precision + recall))
f1_score # 0.4

### ROC Curve를 이용한 모형평가(분류정확도)  ####
# Receiver Operating Characteristic

install.packages("ROCR")
library(ROCR)

# ROCR 패키지 제공 함수 : prediction() -> performance
pr <- prediction(pred, test$RainTomorrow)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf) # x축 : 특이도 , y축 : 민감도

#########################################
###### 다항형 로지스틱 회귀분석 ######
#########################################

install.packages("nnet")
library(nnet)

# 이항분류 vs 다항분류
# sigmoid : 이항분류(y의 결과를 0과 1사이의 확률값으로 만들어준다, cutoff=0.5)
# softmax : 다항분류(y의 결과를 0과 1사이의 확률값으로 만들어준다, 확률의 합=1)
# ex) class1=0.8, class2=0.1, class3=0.1
names(iris)
idx <- sample(nrow(iris), nrow(iris)*0.7)
train_iris <- iris[idx,]
test_iris <- iris[-idx,]

# 다항분류 model : train 이용
model <- multinom(Species ~ ., data=train_iris)

# model 평가 : test 이용
# type="probs" : 0~1 확률(합=1)값으로 나타남
y_pred <- predict(model, test_iris, type="probs") 
y_pred
str(y_pred)

# type = "class" : class형으로 나타남
y_pred <- predict(model, test_iris, type="class")
y_pred
str(y_pred)

range(y_pred) # 3.43495e-129(0) ~  1.00000e+00(1)

y_true <- test_iris$Species
y_true

t <- table(y_true, y_pred)

acc <- (t[1,1] + t[2,2] + t[3,3]) / sum(t)
acc # 0.9333333















