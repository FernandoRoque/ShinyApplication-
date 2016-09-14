
data(iris)
library(ggplot2)
library(rpart)
library(rpart.plot)
library(caret)
library(class)
library(e1071)
library(kknn)
library(randomForest)
library(nnet)


############################################################################3

irisd <- iris[,-c(3,4)]
set.seed(0123)
arbol   <- rpart(Species ~ ., data = irisd, method = "class")
nbayes  <- naiveBayes(Species ~ ., data = irisd)
knn     <- train.kknn(formula = Species ~ ., data = irisd)
svm     <- svm(Species ~ ., data=irisd)
rndfrst <- randomForest(Species~.,data=irisd,ntree=1000,proximity=TRUE)
log     <- capture.output({ redn    <- nnet(Species ~ ., irisd, size = 3)})

############################################################################3

rSL    <- seq(4,8,by=0.01)
rSW    <- seq(2,4.5,by=0.05)
omega  <- expand.grid(Sepal.Length=rSL, Sepal.Width=rSW)

############################################################################3

p_arbol   <- data.frame(predict=predict(arbol, omega, type="class"))
p_nbayes  <- data.frame(predict=predict(nbayes, omega))
p_knn     <- data.frame(predict=predict(knn, omega))
p_svm     <- data.frame(predict=predict(svm, omega, type="class"))
p_rndfrst <- data.frame(predict=predict(rndfrst, omega, type="class"))
p_redn    <- data.frame(predict=predict(redn, omega, type="class"))

np_arbol   <- data.frame(omega, p_arbol)
np_nbayes  <- data.frame(omega, p_nbayes)
np_knn     <- data.frame(omega, p_knn)
np_svm     <- data.frame(omega, p_svm)
np_rndfrst <- data.frame(omega, p_rndfrst)
np_redn    <- data.frame(omega, p_redn)

############################################################################

shinyServer(function(input, output) {

  output$value0 <- renderText({paste("Prediction region for a ",input$mod," model.") })
  

  output$my_plot <- renderPlot({

     model <- switch(input$mod,
                   "Decission Tree" = np_arbol,
                   "K-Nearest neighbor" = np_knn,
                   "Random Forest"= np_rndfrst,
                   "Neural Network" = np_redn,
                   "Support Vector Machine" = np_svm,
                   "Naive Bayes" = np_nbayes)


     pred <- model[model$Sepal.Length==input$SL & model$Sepal.Width==input$SW,]

     q <- ggplot(data=model,aes(Sepal.Length,Sepal.Width, colour=predict))
     q <- q + geom_point(aes(colour=predict),alpha=I(0.1))
     q <- q + geom_point(data=irisd, aes(Sepal.Length,Sepal.Width, colour=Species), size=3, shape=4)
     q <- q + geom_point(data=pred , aes(Sepal.Length,Sepal.Width, colour=predict), size=4)

     q

    })
  
  output$pred <- renderText({
    
    model <- switch(input$mod,
                    "Decission Tree" = np_arbol,
                    "K-Nearest neighbor" = np_knn,
                    "Random Forest"= np_rndfrst,
                    "Neural Network" = np_redn,
                    "Support Vector Machine" = np_svm,
                    "Naive Bayes" = np_nbayes)
  
    as.character(model[model$Sepal.Length==input$SL & model$Sepal.Width==input$SW,][,3])
    
  })
    
})

