import pandas as pd
import csv

################################## 数据读取与预处理 ################################
df = pd.read_excel('E:/works/Harmony/E_Consumer_Behavior_System/project/A5-master/任务123/cph.xlsx')
df.columns = ['用户编号', '缴费日期', '缴费金额']
print(df.isnull().any())  # 检查是否有缺失值

# 根据‘用户编号’进行分组
df1 = df.groupby('用户编号')

# 用户总人数
len1 = len(df1)

# 用户总缴费金额
sum1 = df['缴费金额'].sum()

# 平均缴费金额
avg_money = sum1 / len1

# 平均缴费次数
avg_count = df1.count().mean()['缴费日期']

####################################### 任务1 ######################################
with open('居民客户的用电缴费习惯分析1.csv', mode='w', encoding='gbk', newline='') as f:
    csvwriter = csv.writer(f)
    csvwriter.writerow(["平均缴费次数", "平均缴费金额"])
    csvwriter.writerow([avg_count, avg_money])

# 居民客户的缴费次数
count = df1.count().rename(columns={'缴费日期': '缴费次数'})

# 居民客户的缴费金额
money = df1.sum().rename(columns={'缴费金额': '缴费金额'})

# 合并不同用户的缴费次数和缴费金额
df2 = pd.merge(count, money, on='用户编号')

# 重命名重复的列名
df2.rename(columns={'缴费金额': '缴费金额_y'}, inplace=True)

# 检查 df2 的结构
print(df2.head())
print(df2.columns)

####################################### 任务2 #######################################
with open('居民客户的用电缴费习惯分析2.csv', mode='w', encoding='gbk', newline='') as f:
    csvwriter = csv.writer(f)
    csvwriter.writerow(["用户编号", "客户类型", "缴费次数", "缴费金额"])
    for index, row in df2.iterrows():
        if row['缴费次数'] > avg_count and row['缴费金额_y'] > avg_money:
            customer_type = '高价值型客户'
        elif row['缴费次数'] > avg_count and row['缴费金额_y'] < avg_money:
            customer_type = '大众型客户'
        elif row['缴费次数'] < avg_count and row['缴费金额_y'] > avg_money:
            customer_type = '潜力型客户'
        else:
            customer_type = '低价值型客户'
        csvwriter.writerow([index, customer_type, row['缴费次数'], row['缴费金额_y']])
