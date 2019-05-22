library(shiny)
library(ggvis)
library(dplyr)
shinyServer(function(input, output) {
output$contents <- renderTable({
# input$file1 will be NULL initially. After the user selects
# and uploads a file, head of that data file by default,
# or all rows if selected, will be shown.
req(input$file1)
df <- read.csv(input$file1$datapath,
header = input$header,
sep = input$sep,
quote = input$quote)
if(input$disp == "head") {
return(head(df))
}
else {
return(df)
}
})
samp_data <- reactive({
defects <- df
# generate some random data
samp <- data.frame(defects[1:input$m,]) %>%
mutate(defectsp = samp[,"p"])
})
samp_data_plus <- reactive({
# add the thresholds based on standard deviations, etc
# overall limits, based on null hypothesis of true rate is the
target:
sigma <- 0.24
upper <- input$thresh + 3 * sigma
# create a data frame of the simulated data plus thresholds etc
tmp <- samp_data() %>%
# add the overall limits:
mutate(upper = upper,
thresh = input$thresh) %>%
# add the cumulative results for each run including confidence
intervals:
group_by(run) %>%
mutate(meandefectsp = mean(defectsp),
cumdefects = cumsum(defects),
cumn = cumsum(input$n),
cumdefectp = cumdefects / cumn,
cumsigma = sqrt(cumdefectp * (1 - cumdefectp) / cumn),
cumupper = cumdefectp + 1.96 * cumsigma,
cumlower = cumdefectp - 1.96 * cumsigma)
return(tmp)
})
# draw the two charts:
samp_data_plus %>%
ggvis(x = ~1:input$month, y = ~defectsp) %>%
layer_lines() %>%
#layer_points(fill = ~run) %>%
layer_lines(y = ~upper, stroke := "black", strokeDash := 6,
strokeWidth := 3) %>%
layer_lines(y = ~thresh, stroke := "black", strokeWidth := 3)
%>%
hide_legend(scales = "stroke") %>%
hide_legend(scales = "fill") %>%
add_axis("y", title = "Proportion of defects", title_offset =
50) %>%
bind_shiny("controlChart")
samp_data_plus %>%
#filter(run == 1) %>%
ggvis(x = ~1:input$month) %>%
layer_ribbons(y = ~cumupper, y2 = ~cumlower, fill := "grey") %>%
layer_lines(y = ~thresh, stroke := "black", strokeWidth := 3)
%>%
add_axis("y", title = "Proportion of defects", title_offset =
50) %>%
bind_shiny("ribbonChart")
})
