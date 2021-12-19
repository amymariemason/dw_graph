Audience appreciation values for doctor who, plotted

doctor_who_ai.ipynb was written by Adam Povey and creates dw_qi.png. He did this by copying the data from Wikipedia. 

Amy can't cope with python, so switched it to R to make a csv file of the data. 
She made doctor_who_ptoR.R to make a nice dataframe and ggplot it to a similar graph (saved as doctorwho_plot.svg) to check it was roughly correct and exported as a .csv for others to play with.

Data set in data.csv

868 observations of 12 variables

Doctor: Character from "1" to "13"
Season: Character either as "6" or TV for the TV movie
data_order: int from 1 to 868 for keeping data in time of release order
title: char, name of the episode (same name used for multiple parts)
episode_number: num, episode with multiple parts given as fractions of single number e.g. 6.0, 6.25, 6.5, 6.75 when the 6th episode is in four parts
value: int, the audience appreciation score (see score_type)
Type: char - Old Who, New Who or Movie
score_type: character, Score1, Score2, Score3, Score4 -the audience appreciation score has been calculated in different ways over the years
min/max score: num, minimum and maximum of the audience appreciation score for each Doctor 
min/max ep : num, start and end episode numbers for each doctor




