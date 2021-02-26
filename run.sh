#!/bin/bash
set -x



#每次只需要改name,gpuid,theshold
name=xqb_cash_value
gpu_id=3
threshold=0.5

do_train = 0
do_test = 1

#执行:
#别忘放好data,删除model和outputpredict
#conda activate p2tf112
#cd /data/public/wanghao/code/ai-quality-violations-train/code-format-bert
#nohup sh run.sh &> ../../log/run_xqb_die_merge_train_7532lines_baseline_notaugu.log &
home_dir=$(cd `dirname $0`;pwd)
data_home_dir=$home_dir/data
model_home_dir=$home_dir/model
bert_base_dir=$home_dir/chinese_L-12_H-768_A-12
output_predict=$home_dir/output_predict
conf_dir=$home_dir/conf


#分数据，创建相应的目录

data_dir=$data_home_dir/$name
model_dir=$model_home_dir/$name

function split_data()
{
        # python source/gen_train_dev_test.py $data_dir/${name}_merge
        python source/gen_train_dev_test.py --input_path=$data_dir/${name}_merge
}
#xqb_cash_value
#+ threshold=0.5
#+ lr_num=1e-5
#+ checkpoint_num=200
#+ train_epochs=1

function train()
{
	start_seconds=$(date +%s);
        export CUDA_VISIBLE_DEVICES=$gpu_id
        python source/run_classifier_binary.py \
        --task_name=qc \
        --do_train=true \
        --do_eval=true  \
        --do_predict=false \
        --data_dir=$data_dir \
        --file_prefix=${name}_merge \
        --vocab_file=$bert_base_dir/vocab.txt \
        --bert_config_file=$bert_base_dir/bert_config.json \
        --init_checkpoint=$bert_base_dir/bert_model.ckpt \
        --max_seq_length=200 \
        --train_batch_size=16 \
        --learning_rate=1e-5 \
        --num_train_epochs=1 \
        --output_dir=$model_dir/ \
        --save_checkpoints_steps=200
	end_seconds=$(date +%s);
	echo "Train Cost Time: $(($end_seconds - $start_seconds)) s"
}

function test()
{
	start_seconds=$(date  +%s);
    for filename in `ls $model_dir/model.ckpt-*.index`
    do
        echo $filename
        filename=$(basename ${filename})
        step=${filename%*.index}
        echo $step
        python source/modify_checkpoint.py  $model_dir/checkpoint $model_dir/.checkpoint $step
        mv $model_dir/.checkpoint $model_dir/checkpoint
        file_prefix=${name}_merge
        export CUDA_VISIBLE_DEVICES=$gpu_id
        output_dir=$output_predict/$name
        finanl_res_dir=$output_predict/$name
        python source/run_classifier_binary.py \
        --task_name=qc \
        --do_predict=true \
        --data_dir=$data_dir \
        --file_prefix=$file_prefix \
        --vocab_file=$bert_base_dir/vocab.txt \
        --bert_config_file=$bert_base_dir/bert_config.json \
        --init_checkpoint=$model_dir \
        --max_seq_length=200 \
        --output_dir=$output_dir

        cp $output_dir/test_results.tsv $output_dir/test_results_${step}.tsv

        # python source/sort_and_map_type.py $name $conf_dir/zh_en_type $output_dir/test_results_${step}.tsv $output_dir/${file_prefix}_predict_results_sort_${step}.tsv
        python source/get_model_score.py --input_path=$output_dir/test_results_${step}.tsv --threshold=$threshold
    done
}


function predict()
{
	start_seconds=$(date  +%s);
    for filename in `ls $model_dir/model.ckpt-*.index`
    do
        echo $filename
        filename=$(basename ${filename})
        step=${filename%*.index}
        echo $step
        python source/modify_checkpoint.py  $model_dir/checkpoint $model_dir/.checkpoint $step
        mv $model_dir/.checkpoint $model_dir/checkpoint
        file_prefix=${name}_predict
        export CUDA_VISIBLE_DEVICES=$gpu_id
        output_dir=$output_predict/$name
        finanl_res_dir=$output_predict/$name
        python source/run_classifier_binary.py \
        --task_name=qc \
        --do_predict=true \
        --data_dir=$data_dir \
        --file_prefix=$file_prefix \
        --vocab_file=$bert_base_dir/vocab.txt \
        --bert_config_file=$bert_base_dir/bert_config.json \
        --init_checkpoint=$model_dir \
        --max_seq_length=200 \
        --output_dir=$output_dir

        cp $output_dir/test_results.tsv $output_dir/test_results_${step}.tsv

        # python source/sort_and_map_type.py $name $conf_dir/zh_en_type $output_dir/test_results_${step}.tsv $output_dir/${file_prefix}_predict_results_sort_${step}.tsv
        python source/get_model_score.py --input_path=$output_dir/test_results_${step}.tsv --threshold=$threshold
    done
}


#split_data

if do_train == 1
train
#  nohup sh run.sh &> ../../log/run_xqb_cash_value_train_24647lines_baseline_notaugu.log &

fi

#test Section
if do_test == 1
mv /data/public/wanghao/code/ai-quality-violations-train/code-format-bert/data/xqb_cash_value/xqb_cash_value_merge_test.tsv /data/public/wanghao/code/ai-quality-violations-train/code-format-bert/data/xqb_cash_value/xqb_cash_value_merge_uselesstest.tsv
mv /data/public/wanghao/code/ai-quality-violations-train/code-format-bert/data/xqb_cash_value/xqb_cash_value_predict_test.tsv /data/public/wanghao/code/ai-quality-violations-train/code-format-bert/data/xqb_cash_value/xqb_cash_value_merge_test.tsv
test
fi



# nohup sh run.sh &> ../../log/run_xqb_cash_value_test_15250lines_baseline_notaugu.log &
#predict
