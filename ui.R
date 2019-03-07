##############################################
###  Data Science Bootcamp                 ###
###  Project 1 - Exploratory Visualization ###
###  Zhirui Zhag  / March 2, 2019          ###
###     Youtube Trending Videos in         ###
###  USA, UK, Canada, Germany, France      ###
##############################################

#wc_country = c("USA", "UK", "Canada","Germany","France")
country = c("All Countries" = 1, "USA", "UK", "Canada","Germany","France")
category = c("Entertainment","Music","Howto & Style","Comedy","People & Blogs","News & Politics","Science & Technology",
             "Film & Animation","Sports","Education","Pets & Animals","Gaming","Travel & Events","Autos & Vehicles",
             "Nonprofits & Activism","Shows","Movies", "Trailers")
y_axis = c("Views", "Likes", "Dislikes", "Comments")
x_axis = c("Likes", "Views", "Comments", "Dislikes")
overview_box = c("Views", "Likes", "Comments", "Dislikes")
ui <- dashboardPage(
  skin = 'blue',
  dashboardHeader(title = "The Way To Be a Future Influencer!", titleWidth = 400),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview of All Videos", tabName = "overview", icon = icon("arrows-alt"),
               menuSubItem("Overview", tabName = "general"),
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
              fluidRow(
                tabBox(
                  id = "tabset1", width = 12,
                  tabPanel(id = "tab1",width = 12, 
                           title = "Select Your Video Category", 
                           width = 12,
                           plotlyOutput(outputId = "heatmap", height = "100%", width = "100%"),
                           hr(),
                           plotlyOutput(outputId = "heatmap2", height = "100%", width = "100%")),
                   tabPanel(
                            id = "tab2",
                            width = 12, status ="primary", solidHeader = TRUE,
                            title = "Select Your Target Audience",
                            fluidRow(
                             box(width = 12, height = '100%', selectInput("overview_box", label = h5('Select an attribute'),overview_box)),
                             box(width = 12, status ="primary", solidHeader = TRUE,
                                 title = "Box Plot of Trending Attributes by Country",
                                 plotlyOutput(outputId = "general_boxplot", height = "100%", width = "100%"))))
                  ))
                
      ),
      # overview:barplot, reactive
      tabItem(tabName = 'tile',
              fluidRow(box(width = 6, height = "100%", selectInput("country", h4("Select a country"),country)),
                       box(width = 6, height = 116,  h4('Select Categories'),
                           dropdownButton(
                             label = "Video Category", status = "default", circle = FALSE,
                             checkboxGroupInput('category',label = "",
                                                choices = category, 
                                                selected = category)
                           )
                       ),
                       box(width = 12, status = "primary", solidHeader = TRUE,
                           title = "Barplot by Country and Video Category",
                           htmlOutput(outputId = 'barplot')))
      ),
      
      # attribute: corrplot
      tabItem(tabName = 'corr',
              fluidRow(box(width = 6, height = "100%", selectInput("country_corr", h4("Select a country"),country)),
                       box(width = 12, status ="primary", solidHeader = TRUE,
                           title = "Correlation of Trending Attributes by Country",
                           plotlyOutput(outputId = "corrplot", height = "100%", width = "100%")))
      ),

      # attribute: scatterplot
      tabItem(tabName = 'scatter',
              fluidRow(box(width = 4, height = "100%", selectInput("country_scatter", h4("Select a country"),country)),
                       box(width = 4, height = "100%", selectInput("y_axis", h4("Select Y Axis"),y_axis)),
                       box(width = 4, height = "100%", selectInput("x_axis", h4("Select X Axis"),x_axis)),
                       box(width = 12, status ="primary", solidHeader = TRUE,
                           title = "Scatterplot of Trending Attributes by Category and Country",
                           plotlyOutput(outputId = "scatterplot", height = "100%", width = "100%")))
      ),
      
      # attribute: boxplot
      tabItem(tabName = 'box1', 
              fluidRow(box(width = 6, height = "100%", selectInput("country_box", h4("Select a country"),country)), 
                       box(width = 6, height = "100%", selectInput("attributes", h4("Select a numeric value"), y_axis)),
                       box(width = 12, status ="primary", solidHeader = TRUE,
                           title = "Boxplot of Trending Attributes by Category and Country",
                           plotlyOutput(outputId = "boxplot", height = "100%", width = "100%")))
      ),
                           
      # wordcloud
      tabItem(tabName = 'wc_tab', 
              fluidPage(
                sidebarLayout(
                  # Sidebar with a slider and selection inputs
                  sidebarPanel(
                    selectInput("wc_country", "Choose target audience:",choices = country),
                    selectInput("wc_category", "Choose video category:",choices = category),
                    actionButton("update", "Change"),
                    hr(),
                    sliderInput("freq","Minimum Frequency:",min = 1,  max = 100, value = 30),
                    sliderInput("max","Maximum Number of Words:",min = 1,  max = 300,  value = 100)
                  ),
                  # Show Word Cloud
                  mainPanel(
                    fluidRow(
                      tabBox(id = "tabset2", width = 12,
                             tabPanel(id = "tab3",width = 12,title = "Title Word Cloud", 
                                     plotOutput(outputId = "wc_title")),
                             tabPanel(id = "tab4",width = 12,title = "Tags Word Cloud", 
                                     plotOutput(outputId = "wc_tag")))
                  ))

                ))
        )
      
      
    ) # End of tabItems
  ) # End of dashboardBody
) # End of dashboardPage
