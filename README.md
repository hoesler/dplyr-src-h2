# dplyr-src-h2

[![Build Status](https://travis-ci.org/hoesler/dplyr-src-h2.svg?branch=master)](https://travis-ci.org/hoesler/dplyr-src-h2)

A [dplyr](https://github.com/hadley/dplyr) extension which allows to use an H2 database as a data source.

## Installation
Assuming [devtools](https://github.com/hadley/devtools) is installed, run:
```R
devtools::install_github("hoesler/dbj")
devtools::install_github("hoesler/dplyr-src-h2")
```

## Usage
```R
# Use an H2 URL (http://h2database.com/html/features.html#database_url)
src <- src_h2("mem:")

# Use an H2Connection object
drv <- dbj::driver('org.h2.Driver', resolve(module('com.h2database:h2:1.3.176')))
src <- src_h2(dbConnect(drv, "mem:", "sa", ""))

# Create an H2 src with nycflights13 data (Used for tests, examples, ...)
src <- nycflights13_h2()
```
