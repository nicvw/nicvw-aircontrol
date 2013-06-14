cluetechnologies-aircontrol
===========================

[![Build Status](https://travis-ci.org/cluetechnologies/cluetechnologies-aircontrol.png?branch=master)](https://travis-ci.org/cluetechnologies/cluetechnologies-aircontrol)

## Overview

Install [Ubiquiti airControl](http://wiki.ubnt.com/index.php?title=Aircontrol) on Ubuntu hosts.

## Usage

### class aircontrol

To install airControl with the default parameters

  class { 'aircontrol': }

The defaults are determined by your operating system (e.g. Precise systems have one set) of defaults, Maverick systems have another.  With the default settings airControl 1.4.2 will be installed.

##Limitations

This has been tested on Ubuntu Precise.

##Development

### Running tests

This project contains tests for both [rspec-puppet](http://rspec-puppet.com/). For in-depth information please see the respective documentation.

##Copyright and License

Copyright (C) 2013 [Clue Technologies](https://www.clue.co.za/)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.