# 2014 Tyche Analytics Inc. 

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  filter_defendant_reactive <- reactive({
    filtered_defendant = shinydf_defendant
    
    # Court
    if("all" %in% input$courtfilter){filtered_defendant = shinydf_defendant}  
    else {
      # Problem: Binding to initially non-empty df
      filtered_defendant <- shinydf_defendant[0,]
      for(n in 1:length(input$courtfilter)){
        filtered_defendant <- rbind(filtered_defendant, shinydf_defendant[shinydf_defendant$Court == input$courtfilter[n], ])
      }
    }
    
    # NOS
    tempdf = filtered_defendant[0,]
    if(!("all" %in% input$nosfilter)){
      for(n in 1:length(input$nosfilter)){
        tempdf <- rbind(tempdf, filtered_defendant[filtered_defendant$NOS == input$nosfilter[n], ])
      }
      filtered_defendant <- tempdf
    }    
    
    # Ticker, Defendant, Plaintiff
    if(input$searchquery_ticker != ""){filtered_defendant <- filtered_defendant[grep(input$searchquery_ticker, filtered_defendant$Full.Ticker, ignore.case=T),]}
    if(input$searchquery_defendant != ""){filtered_defendant <- filtered_defendant[grep(input$searchquery_defendant, filtered_defendant$Defendant, ignore.case=T),]}
    if(input$searchquery_plaintiff != ""){filtered_defendant <- filtered_defendant[grep(input$searchquery_plaintiff, filtered_defendant$Plaintiff, ignore.case=T),]}
    return(filtered_defendant)
    
  })
  
  filter_plaintiff_reactive <- reactive({
    filtered_plaintiff = shinydf_plaintiff
    
    # Court
    if("all" %in% input$courtfilter){filtered_plaintiff = shinydf_plaintiff}  
    else {
      # Problem: Binding to initially non-empty df
      filtered_plaintiff <- shinydf_plaintiff[0,]
      for(n in 1:length(input$courtfilter)){
        filtered_plaintiff <- rbind(filtered_plaintiff, shinydf_plaintiff[shinydf_plaintiff$Court == input$courtfilter[n], ])
      }
    }
    
    # NOS
    tempdf = filtered_plaintiff[0,]
    if(!("all" %in% input$nosfilter)){
      for(n in 1:length(input$nosfilter)){
        tempdf <- rbind(tempdf, filtered_plaintiff[filtered_plaintiff$NOS == input$nosfilter[n], ])
      }
      filtered_plaintiff <- tempdf
    }    
    
    # Ticker, Defendant, Plaintiff
    if(input$searchquery_ticker != ""){filtered_plaintiff <- filtered_plaintiff[grep(input$searchquery_ticker, filtered_plaintiff$Full.Ticker, ignore.case=T),]}
    if(input$searchquery_defendant != ""){filtered_plaintiff <- filtered_plaintiff[grep(input$searchquery_defendant, filtered_plaintiff$Defendant, ignore.case=T),]}
    if(input$searchquery_plaintiff != ""){filtered_plaintiff <- filtered_plaintiff[grep(input$searchquery_plaintiff, filtered_plaintiff$Plaintiff, ignore.case=T),]}
    return(filtered_plaintiff)
  })  
  
  output$defPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- sort(shinydf_defendant[, 'TTR'], na.last = NA)
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    output$numresults <- renderPrint({ nrow(filter_defendant_reactive()) })

    #cat("Number of records:", df_size)
    
    # draw the histogram with the specified number of bins
    #hist(x, main = 'Publicly traded company as Defendant', xlab = 'Time to resolution (days)', ylab = 'Number of cases', breaks = bins, col = 'darkred', border = 'white')
    qplot(filter_defendant_reactive()[,13], geom = "freqpoly", binwidth = input$bins + 1, main = 'Publicly traded company as Defendant', xlab = 'Time to resolution (days)', ylab = 'Number of cases') + theme_grey(base_size = 16)
  })
  
  output$plaPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- sort(shinydf_plaintiff[, 'TTR'], na.last = NA)
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
  
    output$numresults <- renderPrint({ nrow(filter_plaintiff_reactive()) })
            
    # draw the histogram with the specified number of bins
    #hist(x, main = 'Publicly traded company as Plaintiff', xlab = 'Time to resolution (days)', ylab = 'Number of cases', breaks = bins, col = 'darkblue', border = 'white')
    qplot(filter_plaintiff_reactive()[,13], geom = "freqpoly", binwidth = input$bins + 1, main = 'Publicly traded company as Plaintiff', xlab = 'Time to resolution (days)', ylab = 'Number of cases') + theme_grey(base_size = 16)
  })

  output$defendant_table <- renderDataTable({
    #shinydf_defendant[, input$show_D_vars, drop = FALSE]
        
    filter_defendant_reactive()[, input$show_table_vars, drop = FALSE]
  }, options = list(pageLength = 10))
  
  output$plaintiff_table <- renderDataTable({

    filter_plaintiff_reactive()[, input$show_table_vars, drop = FALSE]
  }, options = list(pageLength = 10))
  
  ########################
  # Analysis
  ########################
  create_def_model <- reactive({
    def_model <- 0
    if(input$independent_regression_variable == "NOS"){def_model <- lm(as.numeric(filter_defendant_reactive()[,"TTR"]) ~ as.factor(filter_defendant_reactive()[,"NOS"]))}
    else if(input$independent_regression_variable == "Court"){def_model <- lm(as.numeric(filter_defendant_reactive()[,"TTR"]) ~ as.factor(filter_defendant_reactive()[,"Court"]))}
    else if(input$independent_regression_variable == "Industry.Group"){def_model <- lm(as.numeric(filter_defendant_reactive()[,"TTR"]) ~ as.factor(filter_defendant_reactive()[,"Industry.Group"]))}      
    else if(input$independent_regression_variable == "Country"){def_model <- lm(as.numeric(filter_defendant_reactive()[,"TTR"]) ~ as.factor(filter_defendant_reactive()[,"Country"]))}
    else if(input$independent_regression_variable == "Total.Debt"){def_model <- lm(as.numeric(filter_defendant_reactive()[,"TTR"]) ~ as.numeric(filter_defendant_reactive()[,"Total.Debt"]))}    
    else if(input$independent_regression_variable == "Market.Cap.1000USD"){def_model <- lm(as.numeric(filter_defendant_reactive()[,"TTR"]) ~ as.numeric(filter_defendant_reactive()[,"Market.Cap.1000USD"]))}        

    return(def_model)
  })
  
  create_pla_model <- reactive({
    pla_model <- 0
    if(input$independent_regression_variable == "NOS"){pla_model <- lm(as.numeric(filter_plaintiff_reactive()[,"TTR"]) ~ as.factor(filter_plaintiff_reactive()[,"NOS"]))}
    else if(input$independent_regression_variable == "Court"){pla_model <- lm(as.numeric(filter_plaintiff_reactive()[,"TTR"]) ~ as.factor(filter_plaintiff_reactive()[,"Court"]))}
    else if(input$independent_regression_variable == "Industry.Group"){pla_model <- lm(as.numeric(filter_plaintiff_reactive()[,"TTR"]) ~ as.factor(filter_plaintiff_reactive()[,"Industry.Group"]))}      
    else if(input$independent_regression_variable == "Country"){pla_model <- lm(as.numeric(filter_plaintiff_reactive()[,"TTR"]) ~ as.factor(filter_plaintiff_reactive()[,"Country"]))}
    else if(input$independent_regression_variable == "Total.Debt"){pla_model <- lm(as.numeric(filter_plaintiff_reactive()[,"TTR"]) ~ as.numeric(filter_plaintiff_reactive()[,"Total.Debt"]))}    
    else if(input$independent_regression_variable == "Market.Cap.1000USD"){pla_model <- lm(as.numeric(filter_plaintiff_reactive()[,"TTR"]) ~ as.numeric(filter_plaintiff_reactive()[,"Market.Cap.1000USD"]))}        
    
    return(pla_model)
  })
  
  output$defendant_lm_output <- renderPrint({print(summary(create_def_model()))})
  output$plaintiff_lm_output <- renderPrint({print(summary(create_pla_model()))})

  output$def_QQ_plot <- renderPlot({
    plot(create_def_model(), which = 2)
  })

  output$pla_QQ_plot <- renderPlot({
    plot(create_pla_model(), which = 2)
  })

})
