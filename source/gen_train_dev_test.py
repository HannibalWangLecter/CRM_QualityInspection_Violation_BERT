# -*- coding: utf-8 -*- 

from __future__ import division
import random
from argparse import ArgumentParser

'''
only run in binary task
'''


def train_test_divide(args):
    input_path = args.input_path
    train_size = args.train_size
    dev_size = args.dev_size
    test_size = args.test_size

    if train_size <= 0 or dev_size <= 0 or test_size <= 0 or train_size + dev_size + test_size != 10:
        raise ValueError('Data set scale parameter error! Each parameter must be a positive integer and sum to 10.')

    true_lines = []
    false_lines = []
    for line in open(input_path):
        line = line.rstrip('\n')
        sp = line.split('\t')
        if int(sp[1]) == 1:
            true_lines.append(line)
        elif int(sp[1]) == 2:
            false_lines.append(line)
        else:
            print 'error :', sp[0],sp[1]

    print 'true size:', len(true_lines), 'false size:', len(false_lines)

    train_list = []
    dev_list = []
    test_list = []

    for line in true_lines:
        if len(test_list) < len(true_lines) * test_size / 10:
            test_list.append(line)
        elif len(dev_list) < len(true_lines) * dev_size / 10:
            dev_list.append(line)
        else:
            train_list.append(line)

    for line in false_lines:
        if len(test_list) < (len(true_lines) + len(false_lines)) * test_size / 10:
            test_list.append(line)
        elif len(dev_list) < (len(true_lines) + len(false_lines)) * dev_size / 10:
            dev_list.append(line)
        else:
            train_list.append(line)

    print "test_size:", len(test_list), "dev_size:", len(dev_list), "train_size:", len(train_list)
    output_train = open(input_path + "_train.tsv", "w")
    output_dev = open(input_path + "_dev.tsv", "w")
    output_test = open(input_path + "_test.tsv", "w")
    random.shuffle(train_list)
    random.shuffle(dev_list)
    random.shuffle(test_list)
    output_train.write("\n".join(train_list))
    output_dev.write("\n".join(dev_list))
    output_test.write("\n".join(test_list))


if __name__ == '__main__':
    argParser = ArgumentParser()
    argParser.add_argument('--input_path', type=str, help='the source data path')
    argParser.add_argument('--train_size', type=int, default=7)
    argParser.add_argument('--dev_size', type=int, default=1)
    argParser.add_argument('--test_size', type=int, default=2)
    train_test_divide(argParser.parse_args())
