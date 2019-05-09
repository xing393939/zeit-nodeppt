[slide]
# 如何选用 AWS 服务
## 2019-04-18
<style>
.flexbox.vleft {justify-content:normal !important;}
</style>


[slide]
# 目录 {:&.flexbox.vleft}
## 1. AWS 服务介绍
## 2. 网络相关
## 3. EC2 和 EBS
## 4. 数据库和 S3
## 5. IAM 权限管理

[slide]
# AWS 服务介绍 {:&.flexbox.vleft}
## 全球云计算市场份额占41%，排名第一，之后是微软和谷歌。常用服务如下：


[slide]
# 概念 {:&.flexbox.vleft}
## Region，例如ap-southeast-1
## AZ，Available Zone，例如ap-southeast-1a
## VPC，Virtual Private Cloud
## 子网
## 安全组
## 其他网络相关：网络 ACL、系统防火墙


[slide]
# 服务和 IAM {:&.flexbox.vleft}
## 概念：
## IAM 角色
## IAM 策略
## ARN，资源名称
## 示例：
## Lambda 调用 S3 和 控制 EC2
## Mysql 调用 Lambda，[教程](https://docs.aws.amazon.com/zh_cn/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Integrating.Lambda.html)


[slide]
# 常见技术在 AWS 的实现 {:&.flexbox.vleft}
## 无服务化：Lambda
## 大数据数据流 Kafka：Kinesis
## 大数据离线和实时分析：Athena、EMR
## 消息队列: AMAZON MQ


[slide]
# 3. 几个实践 {:&.flexbox.vleft}
## 移动端 Mobile hub
## 第三方登录：Cognito
## 收集日志：Cloudwatch 或者 Kinesis + S3


[slide]
# Thanks
