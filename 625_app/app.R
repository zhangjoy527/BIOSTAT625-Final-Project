#
# This is a Shiny web application for our 625 group project
#

#library(shiny)
library(shinydashboard)
library(gtsummary)
library(gt)
library(corrplot)
library(rsconnect)
library(ggplot2)
pacman::p_load(knitr, ResourceSelection, car)
library(boot)

diabetes_data <- diabetes_data[,-1]

# UI
ui <- dashboardPage(

  # Title
  dashboardHeader(title = "Diabetes indicators dashboard"),

  # Sidebar
  dashboardSidebar(
    selectInput("outcome", "Outcome variable:",
                names(diabetes_data)),
    selectInput("covariates", "Covariates of interest:",
                names(diabetes_data),
                multiple = TRUE)
  ),

  # Body
  dashboardBody(
    tags$head(tags$style(HTML("
                              div.tab-content {
                                height: 90vh;
                                overflow-y: auto;
                                padding: 10px;
                              }
                              "))),
    tags$head(tags$style(".datatables .display {margin-left: 0;}")),
    tabBox(
      # Introduction
      #tabPanel(title = "Introduction & Tutorial"),
      # Summary stats tab
      tabPanel(title = "Summary Statistics",
               gt_output("summary_stats")),
      # EDA histograms
      tabPanel(title = "EDA plots",
               plotOutput("diabetes"),
               plotOutput("age"),
               plotOutput("health_indicator")),
               #plotOutput("first4"),
               #plotOutput("second4"),
               #plotOutput("third3"),
               #plotOutput("fourth3"),
               #plotOutput("fifth3")),
      # Correlation plots
      #tabPanel(title = "Correlations",
      #         plotOutput("corr_plot", height = 750)),
      # Model and Summary table tab
      tabPanel(title = "Model & Model Summary",
               h3("Model:"),
               textOutput("model_formula"),
               h3("Model Summary:"),
               verbatimTextOutput("model_summary")),
      # Model Diagnostics
      tabPanel(title = "Model Diagnostics",
               h3("Hosmer-Lemeshow Goodness of Fit Test:"),
               verbatimTextOutput("hoslem"),
               h3("Pearson Chi-Squared Goodness of Fit Test:"),
               verbatimTextOutput("pearson"),
               h3("Fitted values vs. Pearson residuals:"),
               plotOutput("fittedvpearson_plot", height = 500),
               h3("Cook's Distance Plot:"),
               plotOutput("cooks"),
               h3("Leverage Plots"),
               plotOutput("leverage")),
      #height = '100%',
      width = 12
    )
  )
)

# Server
server <- function(input, output) {
  # Create the output for
  output$model_formula <- renderText({
    model_form <- paste(input$outcome, " ~ ", paste(input$covariates, collapse = " + "))
    model_form
  })

  # Create the summary table
  output$summary_stats <- render_gt(

    diabetes_data %>%
      select(Diabetes_binary, HighBP, HighChol, CholCheck,
             BMI, Smoker, Stroke, HeartDiseaseorAttack, PhysActivity, Fruits,Veggies,HvyAlcoholConsump,HvyAlcoholConsump,AnyHealthcare,NoDocbcCost,GenHlth,MentHlth,PhysHlth,DiffWalk,Sex,Age,Education,Income) %>%
      tbl_summary(
        by = Sex,
        statistic = list(all_categorical() ~ "{n} ({p}%)",
                         BMI     ~ "{mean} ({sd})",
                         MentHlth     ~ "{mean} ({sd})",
                         PhysHlth   ~ "{mean} ({sd})",
                         Age  ~ "{mean} ({sd})"),
        digits = list(all_continuous()  ~ c(2, 2),
                      all_categorical() ~ c(0, 1)),
        type = list(Diabetes_binary   ~ "categorical",
                    HighBP     ~ "categorical",
                    HighChol   ~ "categorical",
                    CholCheck      ~ "categorical",
                    BMI ~ "continuous",
                    Smoker      ~ "categorical",
                    Stroke    ~ "categorical",
                    HeartDiseaseorAttack   ~ "categorical",
                    PhysActivity   ~ "categorical",
                    Fruits ~ "categorical",
                    Veggies ~ "categorical",
                    HvyAlcoholConsump ~ "categorical",
                    AnyHealthcare ~ "categorical",
                    NoDocbcCost ~ "categorical",
                    GenHlth ~ "categorical",
                    MentHlth ~ "continuous",
                    PhysHlth ~ "continuous",
                    DiffWalk ~ "categorical",
                    Age  ~ "continuous",
                    Education ~ "categorical",
                    Income ~ "categorical")
      ) %>%
      modify_header(
        label = "**Variable**",
        all_stat_cols() ~ "**{level}**<br>N = {n} ({style_percent(p, digits=1)}%)") %>%
      modify_caption("Participant characteristics, by gender") %>%
      bold_labels() %>%
      # Include an "overall" column
      add_overall(
        last = FALSE,
        # The ** make it bold
        col_label = "**All participants**<br>N = {N}"
      ) %>%
      as_gt()
  )

  # Create the correlation plot
  output$corr_plot <- renderPlot({
    M <- cor(diabetes_data)
    corrplot(M, method="number")
    height = 2000
  })

  # Create EDA plots
  output$diabetes <- renderPlot({
    ggplot(diabetes_data) +
      geom_bar(aes(x = as.factor(Diabetes_binary), fill = factor(age_cat)), position = "fill") +
      ggtitle("Diabetes Categorized by Age") +
      labs(x = "Diabetes", y = "Proportion", fill = "Age Category") +
      scale_fill_discrete(labels = c("Under 35", "36-49", "50-64", "Over 65"))
  })

  output$age <- renderPlot({
    ggplot(diabetes_data) +
      geom_bar(aes(x = factor(age_cat))) +
      ggtitle("Distribution of Age") +
      labs(x = "Age")
  })

  output$health_indicator <- renderPlot({
    # Histogram of High Blood Pressure
    BP_plot <- ggplot(diabetes_data) +
      geom_bar(aes(x = factor(HighBP), fill = factor(age_cat)), position = "fill") +
      #ggtitle("High Blood Pressure") +
      labs(x = "High Blood Pressure", y = "Proportion", fill = "Age Category") +
      scale_fill_discrete(labels = c("Under 35", "36-49", "50-64", "Over 65"))

    # Histogram of High Chloesterol
    chol_plot <- ggplot(diabetes_data) +
      geom_bar(aes(x = factor(HighChol), fill = factor(age_cat)), position = "fill") +
      #ggtitle("High Cholesterol Categorized by Age") +
      labs(x = "High Cholesterol", y = "Proportion", fill = "Age Category") +
      scale_fill_discrete(labels = c("Under 35", "36-49", "50-64", "Over 65"))

    # Histogram of Smoking Status
    smoker_plot <- ggplot(diabetes_data) +
      geom_bar(aes(x = factor(Smoker), fill = factor(age_cat)), position = "fill") +
      #ggtitle("Smoking Status by Age") +
      labs(x = "Smoking Status", y = "Proportion", fill = "Age Category") +
      scale_fill_discrete(labels = c("Under 35", "36-49", "50-64", "Over 65"))

    # Histogram of Stroke
    stroke_plot <- ggplot(diabetes_data) +
      geom_bar(aes(x = factor(Stroke), fill = factor(age_cat)), position = "fill") +
      #ggtitle("Stroke Categorized by Age") +
      labs(x = "Stroke", y = "Proportion", fill = "Age Category") +
      scale_fill_discrete(labels = c("Under 35", "36-49", "50-64", "Over 65"))

    # Histogram of Heart Disease
    heart_disease_plot <- ggplot(diabetes_data) +
      geom_bar(aes(x = factor(HeartDiseaseorAttack), fill = factor(age_cat)), position = "fill") +
      #ggtitle("Heart Disease Categorized by Age") +
      labs(x = "Heart Disease", y = "Proportion", fill = "Age Category") +
      scale_fill_discrete(labels = c("Under 35", "36-49", "50-64", "Over 65"))

    EDA_health <- ggarrange(BP_plot, chol_plot, stroke_plot, heart_disease_plot, common.legend = T, legend = "bottom")

    annotate_figure(EDA_health, top = text_grob("Health Indicators Categorized by Age",
                                                color = "black", size = 16))
  })

  output$first4 <- renderPlot({
    HighBP <- ggplot(diabetes_data, aes(x = as.factor(HighBP), y = (Diabetes_binary), fill = as.factor(Sex))) +
      geom_col(position = "fill")
    HighChol <- ggplot(diabetes_data, aes(x = as.factor(HighChol), y = (Diabetes_binary), fill = as.factor(Sex))) +
      geom_col(position = "fill")
    CholCheck <- ggplot(diabetes_data, aes(x = as.factor(CholCheck), y = Diabetes_binary, fill = as.factor(Sex))) +
      geom_col(position = "fill")
    Smoker <- ggplot(diabetes_data, aes(x = as.factor(Smoker), y = Diabetes_binary, fill = as.factor(Sex))) +
      geom_col(position = "fill")
    gridExtra::grid.arrange(HighBP, HighChol, CholCheck, Smoker)
  })

  output$second4 <- renderPlot({
    Stroke <- ggplot(diabetes_data, aes(x = as.factor(Stroke), y = (Diabetes_binary), fill = as.factor(Sex))) +
      geom_col(position = "fill")
    HeartDiseaseorAttack <- ggplot(diabetes_data, aes(x = as.factor(HeartDiseaseorAttack), y = (Diabetes_binary), fill = as.factor(Sex))) +
      geom_col(position = "fill")
    PhysActivity <- ggplot(diabetes_data, aes(x = as.factor(PhysActivity), y = Diabetes_binary, fill = as.factor(Sex))) +
      geom_col(position = "fill")
    Fruits <- ggplot(diabetes_data, aes(x = as.factor(Fruits), y = Diabetes_binary, fill = as.factor(Sex))) +
      geom_col(position = "fill")
    gridExtra::grid.arrange(Stroke, HeartDiseaseorAttack, PhysActivity, Fruits)
  })

  output$third3 <- renderPlot({
    Veggies <- ggplot(diabetes_data, aes(x = as.factor(Veggies), y = (Diabetes_binary), fill = as.factor(Sex))) +
      geom_col(position = "fill")
    HvyAlcoholConsump <- ggplot(diabetes_data, aes(x = as.factor(HvyAlcoholConsump), y = (Diabetes_binary), fill = as.factor(Sex))) +
      geom_col(position = "fill")
    AnyHealthcare <- ggplot(diabetes_data, aes(x = as.factor(AnyHealthcare), y = Diabetes_binary, fill = as.factor(Sex))) +
      geom_col(position = "fill")
    gridExtra::grid.arrange(Veggies, HvyAlcoholConsump, AnyHealthcare, ncol = 2)
  })

  output$fourth3 <- renderPlot({
    GenHlth <- ggplot(diabetes_data, aes(x = as.factor(GenHlth), y = (Diabetes_binary), fill = as.factor(Sex))) +
      geom_col(position = "fill")
    DiffWalk <- ggplot(diabetes_data, aes(x = as.factor(DiffWalk), y = (Diabetes_binary), fill = as.factor(Sex))) +
      geom_col(position = "fill")
    Sex <- ggplot(diabetes_data, aes(x = as.factor(Sex), y = Diabetes_binary, fill = as.factor(Sex))) +
      geom_col(position = "fill")
    gridExtra::grid.arrange(GenHlth, DiffWalk, Sex, ncol = 2)
  })

  output$fifth3 <- renderPlot({
    Education <- ggplot(diabetes_data, aes(x = as.factor(Education), y = (Diabetes_binary), fill = as.factor(Sex))) +
      geom_col(position = "fill")
    Income <- ggplot(diabetes_data, aes(x = as.factor(Income), y = (Diabetes_binary), fill = as.factor(Sex))) +
      geom_col(position = "fill")
    NoDocbcCost <- ggplot(diabetes_data, aes(x = as.factor(NoDocbcCost), y = Diabetes_binary, fill = as.factor(Sex))) +
      geom_col(position = "fill")
    gridExtra::grid.arrange(Education, Income, NoDocbcCost, ncol = 2)
  })

  # Create the model summary output using glm()
  output$model_summary <- renderPrint({
    diabetes_data$Diabetes_binary <- factor(diabetes_data$Diabetes_binary)
    diabetes_data$HighBP <- factor(diabetes_data$HighBP)
    diabetes_data$HighChol <- factor(diabetes_data$HighChol)
    diabetes_data$Smoker <- factor(diabetes_data$Smoker)
    diabetes_data$Stroke <- factor(diabetes_data$Stroke)
    diabetes_data$HeartDiseaseorAttack <- factor(diabetes_data$HeartDiseaseorAttack)
    diabetes_data$PhysActivity <- factor(diabetes_data$PhysActivity)
    diabetes_data$Fruits <- factor(diabetes_data$Fruits)
    diabetes_data$Veggies <- factor(diabetes_data$Veggies)
    diabetes_data$HvyAlcoholConsump <- factor(diabetes_data$HvyAlcoholConsump)
    diabetes_data$AnyHealthcare <- factor(diabetes_data$AnyHealthcare)
    diabetes_data$NoDocbcCost <- factor(diabetes_data$NoDocbcCost)
    diabetes_data$GenHlth <- factor(diabetes_data$GenHlth)
    diabetes_data$DiffWalk <- factor(diabetes_data$DiffWalk)
    diabetes_data$Sex <- factor(diabetes_data$Sex)
    diabetes_data$Education <- factor(diabetes_data$Education)
    diabetes_data$Income <- factor(diabetes_data$Income)

    model_form <- as.formula(paste(input$outcome, " ~ ", paste(input$covariates, collapse = " + ")))
    model1 <- glm(data = diabetes_data, formula = model_form, family = binomial("logit"))
    summary(model1)
  })

  # Hosmer Lemeshow
  output$hoslem <- renderPrint({
    model_form <- as.formula(paste(input$outcome, " ~ ", paste(input$covariates, collapse = " + ")))
    model1 <- glm(data = diabetes_data, formula = model_form, family = binomial("logit"))

    hoslem.test(as.numeric(diabetes_data$Diabetes_binary) - 1, fitted(model1))
  })

  # Pearson
  output$pearson <- renderPrint({
    model_form <- as.formula(paste(input$outcome, " ~ ", paste(input$covariates, collapse = " + ")))
    model1 <- glm(data = diabetes_data, formula = model_form, family = binomial("logit"))

    PChiFullrLog <- sum(residuals(model1, type = "pearson") ^ 2)
    df <- nrow(diabetes_data)-ncol(diabetes_data)
    p_value <- pchisq(PChiFullrLog, df, lower.tail = FALSE)

    cat("Chi-square statistic:", PChiFullrLog, "\n")
    cat("degrees of freedom:", df, "\n")
    cat("p-value:", p_value, "\n")
  })

  # Fitted vs. Pearson
  output$fittedvpearson_plot <- renderPlot({
    model_form <- as.formula(paste(input$outcome, " ~ ", paste(input$covariates, collapse = " + ")))
    model1 <- glm(data = diabetes_data, formula = model_form, family = binomial("logit"))

    plot(x = fitted.values(model1), y = residuals(model1, type = "pearson"),
         col = ifelse (diabetes_data[, "Diabetes_binary"] == 1, "blue", "green"))
  })

  # Cook's Distance
  output$cooks <- renderPlot({
    model_form <- as.formula(paste(input$outcome, " ~ ", paste(input$covariates, collapse = " + ")))
    model1 <- glm(data = diabetes_data, formula = model_form, family = binomial("logit"))

    Diagmodel_full_r <- glm.diag(model1)
    plot(x = 1:nrow(diabetes_data), y = Diagmodel_full_r$cook, type = "l", col = "blue", main = "Cook's Distance Plot")
    abline(h = 4/length(Diagmodel_full_r$cook), col = "red", lty = 2)  # Highlight a threshold
  })

  # Leverage
  output$leverage <- renderPlot({
    influence_info <- influence.measures(model2)
    cooksd <- influence_info$infmat[, "cook.d"]
    leverage <- influence_info$infmat[, "hat"]
    std_resid <- influence_info$infmat[, ncol(influence_info$infmat)]

    plot(leverage, pch = 20, main = "Leverage Plot", ylab = "Leverage")

    high_leverage_points <- which(leverage > 2 * mean(leverage))
    points(high_leverage_points, leverage[high_leverage_points], col = "red", pch = 20)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
