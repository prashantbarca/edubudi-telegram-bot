#! /bin/bash
#
# abcd.sh
# Copyright (C) 2015 prashant <prashant@prashant-Lenovo-IdeaPad-Y480>
#
# Distributed under terms of the MIT license.
#


#!/bin/bash
twurl -d "status=$*" /1.1/statuses/update.json
