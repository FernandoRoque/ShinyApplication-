shinyUI(fluidPage(
  
  titlePanel("Iris modeler predictor"),
  
  h5("This application will predict a new species given the value of Sepal.Length and Sepal.Width. It uses",
           "differents models in  order to choose whatever model you want.",
           "Also, it will show a map where you can locate this new species. Note that the original data includes",
           "two aditional variables (Petal Length and Petal Width), but we will use only two variables."),
  br(),
  
  sidebarLayout(
    sidebarPanel(
      
      h3("Input a new observation:"),
      numericInput(inputId = "SL", 
                   label = "Sepal Length", 
                   value = 6, min=4, max=8, step=0.1),

      numericInput(inputId = "SW", 
                   label = "Sepal Width", 
                   value = 3.5, min=2, max=4.5, step=0.1),

      selectInput(inputId = "mod", 
                  label = "Select a model",
                  choices = list("Decission Tree", "K-Nearest neighbor",
                                 "Random Forest", "Neural Network",
                                 "Support Vector Machine", "Naive Bayes"),
                  selected = "Decission Tree")
      
      ),
    
    mainPanel(h3(textOutput("value0")),
              plotOutput(outputId = "my_plot", height = "300px"),
              h4("The new species correspont to:"),h3(textOutput("pred")),
              h6("Note: croses belongs to the original species.")
              
              )
    
  )
  
))
