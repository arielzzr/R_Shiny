##############################################
###  Data Science Bootcamp                 ###
###  Project 1 - Exploratory Visualization ###
###  Zhirui Zhag  / March 2, 2019          ###
###     Youtube Trending Videos in         ###
###  USA, UK, Canada, Germany, France      ###
##############################################

shinyServer(function(input, output) {

  # overview:heatmap, no reactive
  output$heatmap <- renderPlotly({
    m = acast(all_no_spread, category_title~location, value.var="count")
    m[is.na(m)] <- 0
    plot_ly(x = all_no_spread$location, y = all_no_spread$category_title, z = m, 
            type = "heatmap", colors = colorRamp(c('snow', 'darkorange4')))
  })
  
  # overview:barplot, reactive
   barplot_data <- reactive({
     if(input$country == 1){
       all_spread %>% filter(.,category_title %in% input$category)
     }else{
       select(all_spread, category_title, input$country) %>%
          filter(., category_title %in% input$category)}
   })
   output$barplot <- renderGvis({
   gvisBarChart(data = barplot_data(),options = list(chartArea="{left:170,top:0, right:150}",
                                           height = 800,
                                           width = 'automatic',
                                           bar="{groupWidth:'80%'}"
                                           ))
  })
   
  # attribute: corrplot, reactive
  # reactive function doesn't work ??
   corrplot_data <- reactive({
     if(input$country_corr == 1){
       all_corr %>% select(., c(1:5))
     }else{
       filter(all_corr, location == input$country_corr) %>% 
             select(., c(1:5))
     }
   })
   output$corrplot <- renderPlotly({
     cor = cor(corrplot_data())
     plot = ggcorrplot(cor, method = "circle",
                outline.col = "white",
                colors = c("orange", "snow", "darkorange4"),
                legend.title = "Correlation")
     ggplotly(plot)
   })
   
   # attribute: scatterplot, reactive
   # reactive country select fuction not working??
   # how to disable same x/y selection??
   scatter_data <- reactive({
     if(input$country_scatter == 1){
       temp = all_corr %>% select(., x_var = input$x_axis, y_var = input$y_axis, Category.Title)
       sample_n(temp, 2000)
     }else{
       temp = all_corr %>% filter(., location == input$country_scatter) %>% 
         select(., x_var = input$x_axis, y_var = input$y_axis, Category.Title)
       sample_n(temp, 2000)
     }
   })
   output$scatterplot <- renderPlotly({
       graph_x_name <- list(title = input$x_axis)
       graph_y_name <- list(title = input$y_axis)
       plot_ly(scatter_data(), x = ~x_var , y = ~y_var,
               color = ~Category.Title, colors = 'BrBG' ) %>% 
               layout(xaxis = graph_x_name, yaxis = graph_y_name)
   })
   
   # attribute: boxplot, reactive
   box_data <- reactive({
     if(input$country_box == 1){
       temp = all_corr %>% select(., y = input$attributes, Category.Title)
       #sample_n(temp, 2000)
     }else{
       temp = all_corr %>% filter(., location == input$country_box) %>% 
         select(., y = input$attributes, Category.Title)
       #sample_n(temp, 2000)
     }
   })
   output$boxplot <- renderPlotly({
     graph_y_name <- list(title = input$attributes)
     plot_ly(box_data(), y = ~y, color = ~Category.Title, type = "box") %>% 
             layout(yaxis = graph_y_name)
   })
    
})
