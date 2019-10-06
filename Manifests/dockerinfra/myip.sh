#!/bin/bash

#dig +short myip.opendns.com @resolver1.opendns.com
myip=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo "{\"myip\": \"$myip/32\"}"