#' plot pfm countries
#' @param data pfm data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
plotPFM <- function(data) {
  countries <- data  %>%
              select(`2019/20`) %>%
              drop_na() %>%
              unique() %>%
              rename(year="2019/20") %>%
              mutate(year=recode(year, `St Vincent & the Grenadines`="St. Vin. and Gren.", #needed to match rworlddata names
                            DRC="Dem. Rep. Congo",
                            Burma="Myanmar"
                            ))

ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank(),
  legend.position = "none"
)

world <- ne_countries(scale = "medium", returnclass = "sf") %>%
  mutate(reached =
           case_when(
    .$name %in% unlist(countries)  ~ "yes",
    TRUE ~ "no"
  ))

reached <- world %>%
  filter(name %in% unlist(countries)) %>%
  mutate(centroid = st_centroid(geometry))  %>%
  mutate(cent.lat = st_coordinates(centroid)[,1],
         cent.lon = st_coordinates(centroid)[,2]) %>%
  mutate(name=recode(name, Myanmar="Burma"))

pfm_plot = ggplot(world) +
  geom_sf(aes(fill=reached),lwd=0.05, color="grey50") +
  geom_label_repel(data=reached, aes(x=cent.lat, y = cent.lon,
                      label=name), size=2.5,
                      point.padding = 0.2,
                      segment.size = 0,
                      box.padding=0.55,
                      label.size=0,
                      fill="white",
                      nudge_y = ifelse(reached$cent.lon  < 0, -10, 10),
                      nudge_x = ifelse(reached$cent.lat  < 0, -10, 10),
                      force=1) +
  coord_sf(xlim=c(-100, 120), ylim = c(-50, 70), expand=TRUE) +
  theme_bw() +
  ditch_the_axes +
  scale_fill_manual(values=c("grey85","#1b9e77"))

pdf(file="figs/pfm_plot.pdf",
    width=8,
    height=6,
    pointsize=12)
print(pfm_plot)
dev.off()

}
