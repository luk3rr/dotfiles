#!/bin/env sh

# get uptime value
upTime=$(uptime | cut -d " " -f 4-5 | tr -d " ,");

# print value
echo "$upTime";
