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
    m = round(m/colSums(m), 4)
    plot_ly(x = all_no_spread$location, y = all_no_spread$category_title, z = m,
            type = "heatmap", colors = colorRamp(c('snow', 'steelblue'))) %>% 
            colorbar(title = 'Percentage Bar',
                     limits = c(0,0.4), 
                     tickmode = 'array', 
                     tickvals = c(0, 0.1, 0.2, 0.3)) %>% 
      layout(title = "Videos Heatmap by Each Country", size=30 )
      
  })
  # overview:heatmap2, no reactive
  output$heatmap2 <- renderPlotly({
    plot_ly(x = heatmap2$dif_days, y = heatmap2$category_title, z = heatmap2$count,
            type = "heatmap", colors = colorRamp(c('snow', 'steelblue'))) %>% 
      colorbar(title = 'Number of Videos',
               limits = c(0,400), 
               tickmode = 'array', 
               tickvals = c(0, 50, 100, 150, 200, 250, 300)) %>% 
      layout(title = "Videos Heatmap by Publish to Trend Days ", size=30 )
    
  })
  
  
  # overview:general_boxplot, reactive
  overview_box_data <- reactive({
      all_corr %>% select(., var = input$overview_box, Category.Title, location) %>% 
        group_by(., Category.Title, location) %>% 
        summarise(., all = sum(var))
  })
  output$general_boxplot <-renderPlotly({
    graph_y_name <- list(title = input$overview_box)
    xform <- list(categoryoredr = "array", categoryarray = c('Germany','Canada', 'France', 'UK', 'USA'))
    plot_ly(overview_box_data(), x =~location, y =~all, color =~location, type = 'box') %>% 
      layout(yaxis = graph_y_name, xaxis = xform)
  })
  
  # overview:barplot, reactive
   barplot_data <- reactive({
     if(input$country == 1){
       a = all_spread %>% filter(.,category_title %in% input$category) 
       b = mutate(a, total = rowSums(a[,-1])) %>% arrange(., desc(total))
       select(b, -c('total'))
     }else{
      a = all_spread %>% select(., category_title, input$country) %>% 
         filter(.,category_title %in% input$category) #%>% 
      b = mutate(a, total = a[,2]) %>% arrange(., desc(total)) 
      b[,c(1,2)]
     }})
   output$barplot <- renderGvis({
      gvisBarChart(data = barplot_data(),options = list(chartArea="{left:170,top:0, right:150}",
                                           height = 800,
                                           width = 'automatic',
                                           bar="{groupWidth:'80%'}"
                                           ))
  })
   
  # attribute: corrplot, reactive
   corrplot_data <- reactive({
     if(input$country_corr == 1){
       all_corr %>% select(., c(2:5))
     }else{
       filter(all_corr, location == input$country_corr) %>% 
             select(., c(2:5))
     }
   })
   output$corrplot <- renderPlotly({
     cor = cor(corrplot_data())
     plot = ggcorrplot(cor, method = "circle",
                outline.col = "white",
                colors = c("orange", "snow", "steelblue"),
                legend.title = "Correlation")
     ggplotly(plot)
   })
   
   # attribute: scatterplot, reactive
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
       validate(
         need(try(input$x_axis != input$y_axis), "Please select differet X and Y Axis")
       )
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
       sample_n(temp, 2000)
     }else{
       temp = all_corr %>% filter(., location == input$country_box) %>% 
         select(., y = input$attributes, Category.Title)
       sample_n(temp, 2000)
     }
   })
   output$boxplot <- renderPlotly({
     graph_y_name <- list(title = input$attributes)
     plot_ly(box_data(), y = ~y, color = ~Category.Title, type = "box") %>% 
             layout(yaxis = graph_y_name)
   })
   
   # wordcloud: title, reactive
     terms <- reactive({
       # Change when the "update" button is pressed...
       input$update
       # ...but not for anything else
       if(input$country == 1) {
         all_wc %>% 
           filter(category == input$wc_category) %>%
           arrange(desc(title.frequency), desc(tag.frequency)) %>% 
           head(300)
       }else{all_wc %>% filter(., country == input$wc_country, category == input$wc_category)}
       
     })
     
     # Make the wordcloud drawing predictable during a session
     output$wc_title <-renderPlot({
       validate(
         need(try(input$wc_category %in% all_wc$category), "Selected Category does not exist in the source dataset")
       )
       v <- terms()
       v = v %>% select(title.word, title.frequency) 
      wordcloud(v$title.word, v$title.frequency, scale=c(4,0.5),
                       min.freq = input$freq, max.words=input$max,
                       random.order = FALSE, 
                       colors=brewer.pal(8, "Dark2"))
      
     })
     output$wc_tag <-renderPlot({
       validate(
         need(try(input$wc_category %in% all_wc$category), "Selected Category does not exist in the source dataset")
       )
       t <- terms()
       t = t %>% select(tag.word, tag.frequency)
       wordcloud(t$tag.word, t$tag.frequency, scale=c(4,0.5),
                 min.freq = input$freq, max.words=input$max,
                 random.order = FALSE, 
                 colors=brewer.pal(8, "Dark2"))
     })
   
    
})
