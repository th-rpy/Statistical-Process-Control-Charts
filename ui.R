# This is the user-interface definition of a Shiny web application.
You can
# run the application by clicking 'Run App' above.
#
library(shiny)
library(ggvis)
shinyUI(fluidPage(
# Application title
titlePanel("Control chart simulation"),
# Sidebar layout with input and output definitions ----
sidebarLayout(
# Sidebar panel for inputs ----
sidebarPanel(
# Input: Select a file ----
fileInput("file1", "Choose CSV File",
multiple = TRUE,
accept = c("text/csv",
"text/comma-separated-values,text/plain",
".csv")),
# Horizontal line ----
tags$hr(),
# Input: Checkbox if file has header ----
checkboxInput("header", "Header", TRUE),
# Input: Select separator ----
radioButtons("sep", "Separator",
choices = c(Comma = ",",
Semicolon = ";",
Tab = "\t"),
selected = ","),
# Input: Select quotes ----
radioButtons("quote", "Quote",
choices = c(None = "",
"Double Quote" = '"',
"Single Quote" = "'"),
selected = '"'),
# Horizontal line ----
tags$hr(),
# Input: Select number of rows to display ----
radioButtons("disp", "Display",
choices = c(Head = "head",
All = "all"),
selected = "head")
98),
# Main panel for displaying outputs ----
mainPanel(
# Output: Data file ----
tableOutput("contents")
)
),
# Sidebar with a slider input for the number of bins
sidebarLayout(
sidebarPanel(
sliderInput("n",
"Number of samples:",
min = 1,
max = 1000,
value = 30),
sliderInput("reps",
"Number of control chart:",
min = 1,
max = 25,
value = 1),
sliderInput("m",
"Number of Daily to show:",
min = 12,
max = 1000,
value = 24),
numericInput("p",
"True defect rate (which of course is unknown in
the real world)",
min = 0, max = 1, step = 0.01,
value = 0.15),
numericInput("thresh",
"Target maximum defect rate",
min = 0, max = 1, step = 0.01,
value = 0.10),
p(
"This is a simulation of a quality control exercise across
multiple sites for
12 to 60 months where defect is a binary attribute. Choose
the parameters
above to see the impact of different
sample size, number of sites, true defect rate, etc. It is
assumed
that the true defect rate does not change over time or
between sites."),
p("One point this simulation illustrates is that large sample
sizes are needed
each month if you wish to confidently identify faulty sites
in any particular month; but
drawing conclusions over a longer period is more reliable -
so long as defect
99rates really are fairly stable over time in particular
sites."),
p("A second point we illustrate is that even when the true
defect rate is
higher than the target there will be many samples that do not
exceed
the the 'three standard deviations' warning point; and even when
the true
defect rate is lower than the target there will occasionally be
times when
an individual month-site combination is above the warning point
due to chance.")
),
# Show a plot of the generated distribution
mainPanel(
h3("Example control chart/s - one line per site"),
ggvisOutput("controlChart"),
h3("A single site's narrowing confidence interval for defect
rate"),
ggvisOutput("ribbonChart")
)
)
)
)
