# [cognitivemapr]
 [working on this]
What does your project do?
fabulous things
And help you do easy CM analysis
did this work?


## config instruction
R version 4.0.2

[How does the user access your project? (E.g. download, or clone with git clone…)]

[How does the user call the main script(s) that should be executed?]

## installation instructions
To run the code you need to install the following packages:

- tidyverse - built under R version 4.0.5
	v ggplot2 3.3.3     v purrr   0.3.4
	v tibble  3.1.1     v dplyr   1.0.5
	v tidyr   1.1.3     v stringr 1.4.0
	v readr   1.4.0     v forcats 0.5.1
	
- igraph - built under R version 4.0.5
- tidygraph
- ggraph



## operating instructions

## Project organization
- PG = project-generated
- HW = human-writable
- RO = read only
```
.
├── .gitignore
├── CITATION.md
├── LICENSE.md
├── README.md
├── requirements.txt
├── bin                <- Compiled and external code, ignored by git (PG)
│   └── external       <- Any external source code, ignored by git (RO)
├── config             <- Configuration files (HW)
├── data               <- All project data, ignored by git
│   ├── processed      <- The final, canonical data sets for modeling. (PG)
│   ├── raw            <- The original, immutable data dump. (RO)
│   └── temp           <- Intermediate data that has been transformed. (PG)
├── docs               <- Documentation notebook for users (HW)
│   ├── manuscript     <- Manuscript source, e.g., LaTeX, Markdown, etc. (HW)
│   └── reports        <- Other project reports and notebooks (e.g. Jupyter, .Rmd) (HW)
├── results
│   ├── figures        <- Figures for the manuscript or reports (PG)
│   └── output         <- Other output for the manuscript or reports (PG)
└── src                <- Source code for this project (HW)

## file manifest (files included)





## Copy right & License

This project is licensed under the terms of the [GPL-3.0 License](/LICENSE.md)

## Contact info
Femke van Esch: F.a.w.j.vanEsch@uu.nl

## Known bugs
The function calc_degrees_goW.R does not return what it is supposed to

## Troubleshooting

## Credits and acknowledgements

## Citation info

Please cite this project as follows:
Van Esch, Femke A.W.J., Snellens, Jeroen F.A. (forthcoming). 'How to ‘measure’ Ideas. Introducing the method of cognitive mapping to the domain of ideational policy studies'. Journal of European Public Policy.

