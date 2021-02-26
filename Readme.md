**基于 bert 的二分类质检模型 代码整理**

**依赖环境：**

- python==2.7.3
- tensorflow-gpu==1.12.0

**使用方法：**

以【孝亲保-现金价值】为例：

1. clone     项目到本地
2. 将 bert 中文预训练模型 放到     code-format-bert/目录下
3. 准备原始数据     xqb_cash_value_merge 放入 data/xqb_cash_value/ 目录下 原始数据格式每一行为 句子 + '\t' +     label， 其中label 1代表违规，2代表不违规
4. 修改 run.sh 文件中开头的     name=xqb_cash_value
5. 指定要用的 gpu_id     (从0开始计算，指定一块即可)
6. 在 run.sh 下面选择是要     split_data, train 还是 test，其中 split_data 运行一次即可， train运行后会在     model/xqb_cash_value/ 目录中保存最后五个模型（相隔1000），test 会计算 准确率、召回率

**预测方式：**

以【孝亲保-现金价值】为例：

1. 将     xqb_cash_value_predict_test.tsv 放入 /data/xqb_cash_value 中
2. 运行 run.sh 中的     predict 方法