library(purrr)
library(eurostat)
library(dplyr)
library(ggplot2)
library(stringr)
# Data from Eurostat
current_pop <- get_eurostat("demo_r_pjangrp3", time_format = "raw", stringsAsFactors = FALSE) %>%
  filter(time == 2015, 
         nchar(geo) == 4,
         sex == "T", 
         age == "TOTAL") %>% 
  select(-unit) %>% 
  rename(current = values,
         time_current = time)
projected_pop <- get_eurostat("proj_13rpms3", time_format = "raw", stringsAsFactors = FALSE) %>%
  filter(time == 2050, 
         nchar(as.character(geo)) == 4,
         sex == "T", 
         age == "TOTAL") %>% 
  rename(projected = values,
         time_projected = time)

left_join(current_pop,projected_pop) %>% 
  mutate(change = projected / current * 100 -100) %>% 
  dplyr::mutate(cat = cut_to_classes(change, manual = TRUE, manual_breaks = c(-50,-10,0,10,25,130))) %>%
  # dplyr::mutate(cat = cut_to_classes(change)) %>%
  # merge with geodata
  merge_eurostat_geodata(data=.,geocolumn="geo",resolution = "20", output_class = "df", all_regions = FALSE) %>% 
  # plot map
  ggplot(data=., aes(x=long,y=lat,group=group)) +
  geom_polygon(aes(fill=cat),color="dim grey", size=.1) +
  scale_fill_manual(values = c("dim grey","#d7191c","#fdae61","#ffffbf","#a6d96a","#1a9641")) +
  # scale_fill_continuous(trans = 'reverse', ) +
  guides(fill = guide_legend(reverse=T, title = "%")) +
  labs(title="Projected percentage change of the population, by NUTS2 regions, 2015-2050 (%)",
       subtitle="%",
       caption="(C) EuroGeographics for the administrative boundaries 
       Map produced in R with a help from Eurostat-package <github.com/ropengov/eurostat/>") +
  theme_light() + theme(legend.position=c(.8,.8), text=element_text(family="opensans")) +
  coord_map(project="orthographic", xlim=c(-12,44), ylim=c(35,70))
