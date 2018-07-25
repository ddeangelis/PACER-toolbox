# 2014 Tyche Analytics Inc. 

attach(".RData")

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Tyche"),
    
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      strong("Filter Data", style='font-size:20px'),
      hr(),
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 25), width=3,

      selectInput("courtfilter", "Court Code:",  c("<All>" = "all", "California Central" = "cacdce", "California Northern" = "candce", "Delaware" = "dedce", "District of Columbia" = "dcdce", "Florida Southern" = "flsdce", "Illinois Northern" = "ilndce", "Massachusetts" = "madce", "New Jersey" = "njdce", "New York Eastern" = "nyedce", "New York Southern" = "nysdce", "Pennsylvania Eastern" = "paedce", "Texas Eastern" = "txedce", "Texas Northern" = "txndce", "Virginia Eastern" = "vaedce", "Washington Western" = "wawdce"), selected = "all", multiple = TRUE),
      selectInput("nosfilter", "NOS Code:",  c("<All>" = "all", "110 Contract-Insurance" = "110", "160 Contract-Stockholders' Suits" = "160", "190 Contract-Other" = "190", "195 Contract-Product Liability" = "195", "245 Real Property-Tort Product Liability" = "245", "410 Other-Antitrust" = "410", "430 Other-Banks and Banking" = "430", "442 Civil Rights-Employment" = "442", "490 Other-Cable/Sat TV" = "490", "710 Labor-Fair Labor Standards Act" = "710", "830 Property Rights-Patent" = "830", "870 Federal Tax Suits-Taxes" = "870"), selected = "all", multiple = TRUE),
      textInput("searchquery_defendant", "Filter by defendant name:", value = ""),      
      textInput("searchquery_plaintiff", "Filter by plaintiff name:", value = ""),
      textInput("searchquery_ticker", "Filter by ticker:", value = ""),
      hr(),
      tags$p("Number of cases:"),      
      fluidRow(column(10, textOutput("numresults"))),
      hr(),
      
      
      checkboxGroupInput('show_table_vars', strong('Columns to show:'),
                         names(shinydf_defendant), selected = names(shinydf_defendant))
      
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Defendant", plotOutput("defPlot"),
          dataTableOutput("defendant_table")
        ),
        tabPanel("Plaintiff", plotOutput("plaPlot"),
                 dataTableOutput("plaintiff_table")
          
        )
      )
      
    ) 
  ),
  
  hr(),
  
  sidebarLayout(
    sidebarPanel(
      strong("Analyze Data", style='font-size:20px'),
      hr(),
      selectInput("independent_regression_variable", "Independent Variable: ",  c("NOS"="NOS", "Court"="Court", "Industry Group"="Industry.Group", "Country"="Country", "Market Cap"="Market.Cap.1000USD", "Debt"="Total.Debt"))
    ), 
    
    mainPanel(
      strong("Linear Modeling of TTR (experimental)", style='font-size:16px'),
      hr(),
      
      tabsetPanel(
        tabPanel("Defendant", verbatimTextOutput("defendant_lm_output"), plotOutput("def_QQ_plot")),
        tabPanel("Plaintiff", verbatimTextOutput("plaintiff_lm_output"), plotOutput("pla_QQ_plot"))
      )
      
    )
    
  )

))
