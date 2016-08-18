electionsBR
=====

[![Travis-CI Build Status](https://travis-ci.org/silvadenisson/electionsBR.svg?branch=master)](https://travis-ci.org/silvadenisson/electionsBR) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/silvadenisson/electionsBR?branch=master&svg=true)](https://ci.appveyor.com/project/silvadenisson/electionsBR) [![Package-License](https://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)

`electionsBR` contains a set of functions that automatically downloads and aggregates
election data from Brazil (1996-2014), directly from the [Brazilian Superior Electoral Court website (TSE)](http://www.tse.jus.br/eleicoes/estatisticas/repositorio-de-dados-eleitorais).
Among others, there are data available on local and federal elections for all positions (city councillor, mayor, state deputy, federal deputy, governor, and president) disaggregated by state of the Federation, city, zone, and polling stations.

### Installation

For the time being, `electionsBR` is only available at [GitHub](https://github.com/). You can install this pre-release version via:

``` {.r}
if (!require("devtools")) install.packages("devtools")
devtools::install_github("silvadenisson/electionsBR")
```

### How does it work?

`electionsBR` provides ten main functions to dowload and clean Brazilian electoral data:

* candidate_fed()
* candidate_local()
* details_mun_zone_fed()
* details_mun_zone_local()
* legend_fed()
* legend_local()
* party_mun_zone_fed()
* party_mun_zone_local()
* vote_mun_zone_fed()
* vote_mun_zone_local()

To download all the data from a given election, only the `year` argument must be passed to the function call:

``` {.r}
df <- candidate_fed(year = 2002)
```

### Authors

[Denisson Silva](http://denissonsilva.com), [Fernando Meireles](http://fmeireles.com), and Beatriz Costa.

### License

GPL (>= 2)
