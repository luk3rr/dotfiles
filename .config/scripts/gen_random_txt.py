#!/usr/bin/env python3

import random
import string

n = 1024 * 1024 ** 2  # 1 Mb of text

with open('textfile.txt', 'a') as f:
    for i in range(n):
        chars = ''.join([random.choice(string.ascii_letters) for i in range(50)])
        f.write(chars + '\n')
