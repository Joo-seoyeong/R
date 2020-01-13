##########################
## 제13-2장 RM 연습문제 
##########################

# 01. weatherAUS 데이터셋을 대상으로 100개의 Tree와 2개의 분류변수를 파라미터로 지정하여 
# 모델을 생성하고, 분류정확도를 구하시오.
#  조건> subset 생성 : 1,2,22,23 칼럼 제외 

setwd("c:/Rwork/data")
weatherAUS = read.csv("weatherAUS.csv")
str(weatherAUS)
weather <- weatherAUS[,c(-1,-2,-22,-23)]
str(data)

model <- randomForest(RainTomorrow~., data=weather, ntree=100, mtry=2, importance=TRUE, na.action=na.omit) 
# Error in na.fail.default -> 결측치가 있는 경우 발생
# na.action 속성 적용
model
# OOB estimate of  error rate: 14.37%

# 02. 변수의 중요도 평가를 통해서 가장 중요한 변수를 확인하고, 시각화 하시오. 
importance(model)
# MeanDecreaseAccuracy : 분류정확도 개선에 기여하는 변수
# MeanDecreaseGini : 노드 불순도(불확실성) 개선에 기여하는 변수
varImpPlot(model)
# Humidity3pm, Sunshine..
