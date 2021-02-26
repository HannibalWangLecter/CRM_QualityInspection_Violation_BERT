#!/usr/bin/env python
# -*- coding: utf-8 -*-
#######################################################
#
# File Name: modify_checkpoint.py
# Author: lvfeifei
# Email: lvfeifei@shuidi-inc.com
# Created Time: 2020-12-31 16:03:26
#
#######################################################
import sys

def modify(input_path, output_path, model_name):
    output = open(output_path, 'w')

    count = 0
    for line in open(input_path):
        count += 1

        if count == 1:
            output.write('model_checkpoint_path: "' + model_name + '"\n')
        else:
            output.write(line)


if __name__ == '__main__':
    input_path = sys.argv[1]
    output_path = sys.argv[2]
    model_name = sys.argv[3]
    modify(input_path, output_path, model_name)
