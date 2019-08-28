library(tidyverse)
library(tabulizer)
library(openxlsx)

# download the by-state file and then reference the file in the following line; it will load a mini-ui via shiny in which you'll need to highlight the table on p. 2

nics <- extract_areas('~/Downloads/active-records-nics-indices-by-state-2018.pdf', 2)

# (note: tried to capture the areas with locate_areas, then programatically do extract_areas, and tabulizer didn't like it, for whatever reason :shrug: )

# then run this to create a tibble from it:

nics <- nics[[1]] %>%
  as_tibble() %>%
  set_names(c('State', 'Felony', 'Indictment','FugitiveFromJustice','ControlledSubstance','AdjudicatedMentalHealth','Alien','DishonorableDischarge','RenouncedCitizenship','DVPO','MCDV','StateProhibitor','Total')) %>%
  mutate_all(function(v) gsub(x=v, pattern=',', replacement='')) %>%
  mutate_at(vars(-State), as.integer)

# and then this, if you want to write it into an Excel spreadsheet:

write.xlsx(nics, '/tmp/nics.xlsx')