#!/bin/env sh

temp=$(sensors | grep -i CPU | head -n1 | sed -r 's/.*:\s+[\+-]?(.*C)\s+.*/\1/')

echo -e $temp
