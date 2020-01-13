#################################
## <제12장 연습문제>
################################# 

# 01. mpg의 엔진크기(displ)가 고속도록주행마일(hwy)에 어떤 영향을 미치는가?    
# <조건1> 단순선형회귀모델 생성 
# <조건2> 회귀선 시각화 
# <조건3> 회귀분석 결과 해석 : 모델 유의성검정, 설명력, x변수 유의성 검정  
setwd("c:/Rwork/data")
library(ggplot2)
data(mpg)
str(mpg)
x <- mpg$displ
y <- mpg$hwy
df <- data.frame(x,y)
model <- lm(y~x, data=df)
model
# (Intercept)  x  
# 35.698       -3.531
# 엔진 크기에 따라 고속도로주행마일수는 감소한다

plot(x,y)
# text 추가
text(df$x, df$y, labels = df$y,cex=0.7, pos=3, col="blue")
# pos=c(1:3) : 아래,옆,위위
abline(model,col="red")

summary(model)
# 모델 유의성 검정 : F-statistic: 329.5 on 1 and 232 DF,  p-value: < 2.2e-16 -> 유의하다
# 설명력 : Adjusted R-squared:  0.585
# x변수 유의성 검정 : t=-18.15   p<2e-16 -> 유의하다

# 02. product 데이터셋을 이용하여 다음과 같은 단계로 다중회귀분석을 수행하시오.
setwd("c:/Rwork/data")
product <- read.csv("product.csv", header=TRUE)
str(product) # data.frame:	264 obs. of  3 variables
#  단계1 : 학습데이터(train),검정데이터(test)를 7 : 3 비율로 샘플링
idx <- sample(x=nrow(product), size=nrow(product)*0.7, replace=FALSE)
idx
train <- product[idx,]
test <- product[-idx,]
dim(train) # 184 3
dim(test) # 80 3

#  단계2 : 학습데이터 이용 회귀모델 생성 
#           변수 모델링) y변수 : 제품_만족도, x변수 : 제품_적절성, 제품_친밀도
pro_model <- lm(제품_만족도 ~ ., data=train)
pro_model
# (Intercept)  제품_친밀도  제품_적절성  
# 0.69244      0.08253      0.69732
# 제품_만족도 = 0.69244 + 0.08253*제품_친밀도 + 0.69732*제품_적절성

#  단계3 : 검정데이터 이용 모델 예측치 생성 
y_pred <- predict(pro_model, test) # y의 예측치
y_pred
y_true <- test$제품_만족도 # y의 정답
y_true

#  단계4 : 모델 평가 : cor()함수 이용  
cor(y_pred, y_true) # 0.7595451

# 03. ggplot2패키지에서 제공하는 diamonds 데이터 셋을 대상으로 
# carat, table, depth 변수 중 다이아몬드의 가격(price)에 영향을 
# 미치는 관계를 다중회귀 분석을 이용하여 예측하시오.
#조건1) 다이아몬드 가격 결정에 가장 큰 영향을 미치는 변수는?
#조건2) 다중회귀 분석 결과를 정(+)과 부(-) 관계로 해설

library(ggplot2)
data(diamonds)

