

function(section){
knitr::opts_chunk$set(
  echo=F,
  message=F,
  warning=F,
  fig.path = "../figs/",
  cache = FALSE,
  fig.process = function(x) {
    x2 = sub('-\\d+([.][a-z]+)$', '\\1', x)
    if (file.rename(x, x2)) x2 else x
  }
)

sections <- c("titlepage",
              "frontmatter",
              "education"
)

knitAll(files=sprintf("%s/%s", sections, sections))
}
