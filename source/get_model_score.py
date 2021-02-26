# -*- coding: utf-8 -*-

from __future__ import division
from argparse import ArgumentParser


def get_score(i_args):
    input_path = i_args.input_path
    TP = 0
    TN = 0
    FP = 0
    FN = 0
    count = 0
    error_count = 0
    for line in open(input_path):
        count += 1
        line = line.rstrip('\n')
        sp = line.split('\t')
        sentence, label, pos_score, neg_score,_ = sp
        score = float(pos_score)
        label = int(label)
        if score >= i_args.threshold:
            # predict 1
            if label == 1:
                TP += 1
            elif label == 2:
                FP += 1
            else:
                error_count += 1
        else:
            if label == 1:
                FN += 1
            elif label == 2:
                TN += 1
            else:
                error_count += 1
    print TP,FP,TN,FN
    Precision = TP / (TP + FP)
    Recall = TP / (TP + FN)
    print 'Total num is %d, error sample num %d, Precision is %.4f, Recall is %.4f' % \
          (count, error_count, Precision, Recall)


if __name__ == '__main__':
    argParser = ArgumentParser()
    argParser.add_argument('--input_path', type=str)
    argParser.add_argument('--threshold', type=float,default=0.5)
    args = argParser.parse_args()
    get_score(args)
