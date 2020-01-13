# chap13_2_RandomForest

# 패키지 설치
install.packages("randomForest")
library(randomForest)

names(iris)


####################################
##### 분류트리(y변수 : 범주형) #####
####################################

# 1. model 생성
model <- randomForest(Species~., data = iris)
# 500 dataset 생성 -> 500 tree(model) 생성 -> 예측치
model
# Number of trees: 500
# No. of variables tried at each split: 2 => 노드를 분류하는데 사용하는 변수의 갯수
# OOB estimate of  error rate: 4.67% (오분류율)
# 분류정확도 : 약 96%
# Confusion matrix:
#            setosa versicolor virginica class.error
# setosa     50     0          0         0.00
# versicolor 0      47         3         0.06
# virginica  0      4          46        0.08

(50+47+46) / 150 # 0.9533333

?randomForest
model2 <- randomForest(Species~., data = iris, ntree=400, mtry=2, importance=TRUE, na.action=na.omit)
model2

importance(model2)

#  MeanDecreaseGini : 노드 불순도(불확실성) 개선에 기여하는 변수

varImpPlot(model2)

####################################
##### 회귀트리(y변수 : 연속형) #####
####################################

library(MASS)
data("Boston")

str(Boston)
#crim : 도시 1인당 범죄율 
#zn : 25,000 평방피트를 초과하는 거주지역 비율
#indus : 비상업지역이 점유하고 있는 토지 비율  
#chas : 찰스강에 대한 더미변수(1:강의 경계 위치, 0:아닌 경우)
#nox : 10ppm 당 농축 일산화질소 
#rm : 주택 1가구당 평균 방의 개수 
#age : 1940년 이전에 건축된 소유주택 비율 
#dis : 5개 보스턴 직업센터까지의 접근성 지수  
#rad : 고속도로 접근성 지수 
#tax : 10,000 달러 당 재산세율 
#ptratio : 도시별 학생/교사 비율 
#black : 자치 도시별 흑인 비율 
#lstat : 하위계층 비율 
#medv(y) : 소유 주택가격 중앙값 (단위 : $1,000)

# y= medv
# x=13칼럼

p=14
(1/3) * p # 4.666667

mtry = round((1/3)*p) # 반올림
mtry = floor((1/3)*p) # 절삭
mtry # 4

model3 <- randomForest(medv~., data = Boston, ntree=500, mtry=mtry, importance=TRUE, na.action=na.omit)
model3 # Mean of squared residuals: 10.46048 / 분산 : 87.61

# 중요 변수 시각화
varImpPlot(model3)







