Task 1: Interactive Dashboard
For this research the dashboard is being built using PowerBI and the data is centered around education. It start off with the title of the dashboard build with
the measure and visualize using a card visual.
The next was a country filter which only allow a single selection to be able to filter data by country. 
This visual only works for  the line chart which will be discussed later in this section.
The next section contain three visuals; a tree map that visualized percentage of education to overall expenditure, 
a clustered column chart that compares
the various education level expenditure by countr and a coumn chart that visual the education expenditire compared 
to overall public institution expenditure.
All of which has a drill through of year that can be gotten to by clicking the country you want to see its year break down
The next level is the line chart that shows the trend of level of education attained by year. This is the visuals the country 
filter works on to be able to 
see the trend for each country separately.
The last level is the matrix visual that shows the country with the year drillthrough in the row and the value of each of the 
indicator in the column


Task 2 R Statistical Analysis
The R analysis uses statistical method to analysis the data. The step taken in the analysis is as follow:
1. Data Load
The data is loaded into the studio using the read.table and passing the argument file which is the path to the dataset, and specifiying the delimiter "," 
and the header is TRUE. This loads the data into the studio

2. Data Preparaton
The data preparation is done first with the table header which take the first 100 rows to discard the empty rows that comes with it.
It then drop the redundant code column not needed during the analysis.
It also replace the double dot (..) which means empty value with NA. This is to allow the system to be able to treat is as empty value.
It then uses the function pivot_longer and pivot wider to unpivot and pivot the table. The pivot takes the years column name as a column value and the 
pivot_wider takes the indicator value names as the column name.
It also clean the year value to contain only yeat, by using str_replace to replace unwanted values
The column container value is then converted to a numeric value after which the na is replaced with the aggregate of each column

3. Analysis: The analysis is done in four categories:
a. comparative analysis:
Compararative analysis is done by comparing the the indicator mean value across country to see how each country is doing compared to each other. The geom_bar function of 
the ggplot is also used for this wth other attributes to builtify it, such as the ggtitle to put title to it.

b. Regresson Analysis:
This used the lm functon analysis to perfrom but the simple linear and multilinear regression of the indicator. The lm also also allow summarzaton of the metrics
which the coefficient and intercept is one of it. Then the  model is plot to derive both the residual graph.

c. Time series Analyss:
This is done by performing the trend anlysis of the dataset using the ggplot geompoint function to create a liine chart that visualize the indicator.
To do this the year column needs to be converted to a date format so t can be a time seres data. The conversion is done by converting the year to first
day of each year of the dataset available.

d. Descriptve analysis:
This is performed by using the summary function of R. It takes the dataframe argument (the dataset) and output the summarizaton such as mean, median,
minimum, maximum and interquartile range.