##############################################
###  Data Science Bootcamp                 ###
###  Project 1 - Exploratory Visualization ###
###  Zhirui Zhag  / March 2, 2019          ###
###     Youtube Trending Videos in         ###
###  USA, UK, Canada, Germany, France      ###
##############################################

country = c("All Countries" = 1, "USA", "UK", "Canada","Germany","France")
category = c("Entertainment","Music","Howto & Style","Comedy","People & Blogs","News & Politics","Science & Technology",
             "Film & Animation","Sports","Education","Pets & Animals","Gaming","Travel & Events","Autos & Vehicles",
             "Nonprofits & Activism","Shows","Movies","Trailers")
y_axis = c("Views", "Likes", "Dislikes", "Comments")
x_axis = c("Likes", "Views", "Dislikes", "Comments")
ui <- dashboardPage(
  skin = 'y',
  dashboardHeader(title = "Your Way To Be a Future Influencer!", titleWidth = 400),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview of All Videos", tabName = "overview", icon = icon("arrows-alt"),
               menuSubItem("By Video Category", tabName = "general"),
               menuSubItem("By Video Category and Country", tabName = "tile")),
      menuItem("Trending Video Attributes", tabName = "attribute", icon = icon("bar-chart"),
               menuSubItem("Correlation plot", tabName = "corr"),
               menuSubItem("Scatter plot", tabName = "scatter"),
               menuSubItem("Box plot", tabName = "box1")),
      menuItem("word cloud", tabName = "wc_tab", icon = icon("cloud"))
      #menuItem("data Explorer", tabName = "Data_Explorer", icon = icon("th"))
    )
  ),
  
  
  dashboardBody(
    tabItems(
      
      # overview:heatmap, no reactive
      tabItem(tabName = 'general', 
              fluidRow(box(width = 12, status ="warning", solidHeader = TRUE,
                           title = "Heatmap by Video Category",
                           plotlyOutput(outputId = "heatmap", height = "100%", width = "100%")))
      ),
      # overview:barplot, reactive
      tabItem(tabName = 'tile',
              fluidRow(box(width = 6, height = "100%", selectInput("country", h4("Select a country"),country)),
                       box(width = 6, height = 116,  h4('Select Categories'),
                           dropdownButton(
                             label = "Video Category", status = "default", circle = FALSE,
                             #actionButton(inputId = "all", label = "(Un)select all"),
                             #checkboxGroupInput(inputId = "category", label = "", choices = category)
                             checkboxGroupInput('category',label = "",
                                                choices = category, 
                                                selected = category)
                           )
                       ),
                       box(width = 12, status = "warning", solidHeader = TRUE,
                           title = "Barplot by Country and Video Category",
                           htmlOutput(outputId = 'barplot')))
      ),
      
      # attribute: corrplot
      tabItem(tabName = 'corr',
              fluidRow(box(width = 6, height = "100%", selectInput("country_corr", h4("Select a country"),country)),
                       box(width = 12, status ="warning", solidHeader = TRUE,
                           title = "Correlation of Trending Attributes by Country",
                           plotlyOutput(outputId = "corrplot", height = "100%", width = "100%")))
                       #plotlyOutput(outputId = "heatmap", height = "100%", width = "100%")))
      ),

      # attribute: scatterplot
      tabItem(tabName = 'scatter',
              fluidRow(box(width = 4, height = "100%", selectInput("country_scatter", h4("Select a country"),country)),
                       box(width = 4, height = "100%", selectInput("y_axis", h4("Select Y Axis"),y_axis)),
                       box(width = 4, height = "100%", selectInput("x_axis", h4("Select X Axis"),x_axis)),
                       box(width = 12, status ="warning", solidHeader = TRUE,
                           title = "Scatterplot of Trending Attributes by Category and Country",
                           plotlyOutput(outputId = "scatterplot", height = "100%", width = "100%")))
              #plotlyOutput(outputId = "heatmap", height = "100%", width = "100%")))
      ),
      
      # attribute: boxplot
      tabItem(tabName = 'box1', 
              fluidRow(box(width = 6, height = "100%", selectInput("country_box", h4("Select a country"),country)), 
                       box(width = 6, height = "100%", selectInput("attributes", h4("Select a numeric value"), y_axis)),
                       box(width = 12, status ="warning", solidHeader = TRUE,
                           title = "Boxplot of Trending Attributes by Category and Country",
                           plotlyOutput(outputId = "boxplot", height = "100%", width = "100%")))
      ),
                           
      # wordcloud
      tabItem(tabName = 'wc_tab', 
              fluidRow(box(width = 6, height = "100%", selectInput("country_word", h4("Select a Country"),country)), 
                       box(width = 6, height = "100%", 
                           selectInput("category_word", h4("Select a Video Category"), category, selected = 'Entertainment')),
                       box(width = 6, status ="warning", solidHeader = TRUE,
                           title = "Wordcloud of Video Titles by Category and Country",
                           plotOutput(outputId = "wc_title", height = "100%", width = "100%")),
                       box(width = 6, status ="warning", solidHeader = TRUE,
                           title = "Wordcloud of Video Tags by Category and Country",
                           plotOutput(outputId = "wc_tag", height = "100%", width = "100%")))
                    
       )
      
    ) # End of tabItems
  ) # End of dashboardBody
) # End of dashboardPage