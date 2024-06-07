const express = require('express');
const bodyParser = require('body-parser');
const { Sequelize, DataTypes } = require('sequelize');
const csv = require('csv-parser');
const fs = require('fs');
const { exec } = require('child_process');
const iconv = require('iconv-lite');

const app = express();
const port = 3000;
const csvFilePath = 'E:/E_Consumer_Behavior_System/E_Consumer_Behavior_System/project/Electricity_Consumer_Behavior/task123/居民客户的用电缴费习惯分析1.csv';

// 初始化SQLite数据库连接
const sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: './database.sqlite' // SQLite数据库文件路径
});

app.use(bodyParser.json());



const User = sequelize.define('User', {
    username: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false
    }
});

const PaymentHabit = sequelize.define('PaymentHabit', {}, { timestamps: false });
const CustomerType = sequelize.define('CustomerType', {}, { timestamps: false });
const PredictedUsage = sequelize.define('PredictedUsage', {}, { timestamps: false });

const OperationLog = sequelize.define('OperationLog', {
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    timestamp: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
    },
    operation: {
        type: DataTypes.STRING,
        allowNull: false
    }
});

// 同步数据库
sequelize.sync().then(() => {
    console.log('SQLite Database & tables created!');
});

// 结构体来存储平均缴费金额与平均缴费次数
let paymentStats = {
    avgAmount: 0,
    avgCount: 0
};

// 结构体来存储CSV文件内容
let csv2Data = [];
let csv3Data = [];

// 读取CSV并存储平均缴费金额与平均缴费次数
const readCSVAndCalculateStats = (filePath) => {
    let totalAmount = 0;
    let totalCount = 0;
    let recordCount = 0;

    // 使用 iconv-lite 指定编码格式为GBK
    const fileStream = fs.createReadStream(filePath).pipe(iconv.decodeStream('GBK'));

    fileStream
        .pipe(csv())
        .on('data', (row) => {
            // 使用正确的列名来解析数据
            totalAmount += parseFloat(row['平均缴费金额']);
            totalCount += parseFloat(row['平均缴费次数']); // 使用 parseFloat 来处理小数
            recordCount++;
        })
        .on('end', () => {
            if (recordCount > 0) {
                paymentStats.avgAmount = totalAmount / recordCount;
                paymentStats.avgCount = totalCount / recordCount;
            } else {
                paymentStats.avgAmount = 0;
                paymentStats.avgCount = 0;
            }
            console.log('avgAmount： '+ paymentStats.avgAmount);
            console.log('avgCount： '+ paymentStats.avgCount);
            console.log('CSV file successfully processed');
        });
};

// 读取CSV文件内容并存储
const readCSVFile = (filePath, storageArray, encoding) => {
    // 创建可读流，并指定编码格式
    const fileStream = fs.createReadStream(filePath).pipe(iconv.decodeStream(encoding));

    fileStream
        .pipe(csv())
        .on('data', (row) => {
            storageArray.push(row);
        })
        .on('end', () => {
            console.log(`CSV file ${filePath} successfully processed`);
        })
        .on('error', (err) => {
            console.error(`Error processing CSV file ${filePath}:`, err);
        });
};

// 初始化数据读取
readCSVAndCalculateStats(csvFilePath);
readCSVFile('E:/E_Consumer_Behavior_System/E_Consumer_Behavior_System/project/Electricity_Consumer_Behavior/task123/居民客户的用电缴费习惯分析2.csv', csv2Data,'GBK');
readCSVFile('E:/E_Consumer_Behavior_System/E_Consumer_Behavior_System/project/Electricity_Consumer_Behavior/task123/居民客户的用电缴费习惯分析3.csv', csv3Data,'UTF-8');
// API端点以返回计算的平均值
app.get('/payment-stats', (req, res) => {
    res.json(paymentStats);
});

// API端点以返回CSV2的内容
app.get('/csv2-data', (req, res) => {
    res.json(csv2Data);
});

// API端点以返回CSV3的内容
app.get('/csv3-data', (req, res) => {
    res.json(csv3Data);
});



// 检查用户名是否存在
app.post('/check-username', async (req, res) => {
    const { username } = req.body;

    try {
        const user = await User.findOne({ where: { username } });
        res.status(200).json({ exists: !!user });
    } catch (err) {
        res.status(500).json({ message: 'Internal server error' });
    }
});

// 注册用户
app.post('/register', async (req, res) => {
    const { username, password } = req.body;

    try {
        const userExists = await User.findOne({ where: { username } });
        if (userExists) {
            return res.status(400).json({ message: 'User already exists' });
        }

        const newUser = await User.create({ username, password });
        res.status(201).json({ message: 'User registered successfully' });
    } catch (err) {
        console.error('Error registering user', err);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// 用户登录
app.post('/login', async (req, res) => {
    const { username, password } = req.body;

    try {
        const user = await User.findOne({ where: { username, password } });
        if (!user) {
            return res.status(400).json({ message: 'Invalid username or password' });
        }

        res.status(200).json({ message: 'Login successful' });
    } catch (err) {
        console.error('Error logging in', err);
        res.status(500).json({ message: 'Internal server error' });
    }
});


// 操作记录相关的API端点

// 增加操作记录
app.post('/log-operation', async (req, res) => {
    const { operation } = req.body;

    try {
        const newLog = await OperationLog.create({ operation });
        res.status(201).json({ message: 'Operation logged successfully', log: newLog });
    } catch (err) {
        console.error('Error logging operation', err);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// 删除操作记录
app.delete('/log-operation/:id', async (req, res) => {
    const { id } = req.params;

    try {
        const log = await OperationLog.findByPk(id);
        if (!log) {
            return res.status(404).json({ message: 'Operation log not found' });
        }

        await log.destroy();
        res.status(200).json({ message: 'Operation log deleted successfully' });
    } catch (err) {
        console.error('Error deleting operation log', err);
        res.status(500).json({ message: 'Internal server error' });
    }
});

// 查询操作记录
app.get('/log-operation', async (req, res) => {
    try {
        const logs = await OperationLog.findAll();
        res.status(200).json(logs);
    } catch (err) {
        console.error('Error fetching operation logs', err);
        res.status(500).json({ message: 'Internal server error' });
    }
});



// 处理根路径
app.get('/', (req, res) => {
    res.send('Welcome to the homepage!');
});

// 启动服务器
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
