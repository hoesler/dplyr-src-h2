# dplyr-src-h2

[![Build Status](https://travis-ci.org/hoesler/dplyr-src-h2.svg?branch=master)](https://travis-ci.org/hoesler/dplyr-src-h2)

A [dplyr](https://github.com/hadley/dplyr) extension which allows to use a H2 database as a data source.

## Installation
Assuming [devtools](https://github.com/hadley/devtools) is installed, run:
```R
devtools::install_github("hoesler/dbj")
devtools::install_github("hoesler/dbj-h2")
devtools::install_github("hoesler/dplyr-src-h2")
```

## Usage
```R
src <- src_h2("mem:") # Use a URL (http://h2database.com/html/features.html#database_url)
src <- src_h2(dbConnect(dbj.h2::driver(), "mem:", "sa", "")) # Use a H2Connection
src <- nycflights13_h2() # A H2 src with nycflights13 data (Used for tests, examples, ...)
```
