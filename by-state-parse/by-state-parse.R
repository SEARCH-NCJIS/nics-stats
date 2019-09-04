library(tidyverse)
library(tabulizer)
library(openxlsx)

# download the by-state file and then reference the file in the following line; it will load a mini-ui via shiny in which you'll need to highlight the table on whatever page it occurs

nics <- list()

nics$df2016 <- extract_areas('raw-pdfs/2016.pdf', 4) %>% .[[1]]
nics$df2017 <- extract_areas('raw-pdfs/2017.pdf', 4) %>% .[[1]]
nics$df2018 <- extract_areas('raw-pdfs/2018.pdf', 2) %>% .[[1]]

# (note: tried to capture the areas with locate_areas, then programatically do extract_areas, and tabulizer didn't like it, for whatever reason :shrug: )

# then run this to create a tibble from it:

nicsClean <- nics %>%
  map(function(tdf) {
    tdf %>% as_tibble() %>%
      set_names(c('State', 'Felony', 'Indictment','FugitiveFromJustice','ControlledSubstance','AdjudicatedMentalHealth','Alien','DishonorableDischarge','RenouncedCitizenship','DVPO','MCDV','StateProhibitor','Total')) %>%
      mutate_all(function(v) gsub(x=v, pattern=',', replacement='')) %>%
      mutate_at(vars(-State), as.integer)
  })

# and then this, if you want to write it into an Excel spreadsheet:

write.xlsx(nicsClean, 'output/nics.xlsx')