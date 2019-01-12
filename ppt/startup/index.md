[slide]
# 《创业就是要细分垄断》读记
## 2019-01-16
<style>
.flexbox.vleft {justify-content:normal !important;}
</style>

[slide]
# 目录 {:&.flexbox.vleft}
## 一，监控哪些指标、监控的好处
## 二，第三方服务vs自建方案
## 三，自建方案(基于Redis队列)
## 四，自建方案(基于Sentry客户端SDK)
## 五，待完善的地方

[slide]
# 一，监控哪些指标、监控的好处 {:&.flexbox.vleft}
## 监控哪些指标
* pv、pv响应时间
* 资源：数据库，缓存，Api接口
* 错误日志

## 监控的好处
* 光有 Web 日志是不够的
* 对优化代码有精确的数据参考
* 更清楚业务的服务依赖关系

[slide]
# 二，第三方服务vs自建方案 {:&.flexbox.vleft}
## 国外服务
* New Relic
* AppDynamics

## 国内服务
* oneAPM
* 听云
* apm.aliyun.com
* 透视宝

[slide]
# 二，第三方服务vs自建方案 {:&.flexbox.vleft}
## 自建方案

<img src="/src/zijian.jpg" width="770" height="339">

[slide]
# 三，自建方案(基于Redis队列) {:&.flexbox.vleft}
## 在路由处加自定义装饰器

```python
def perf_logging(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        try:
            time_start = time.time()
            ret = func(*args, **kwargs)
            time_end = time.time()
            redis_conn.lpush("apm:0x00000001", json.dumps({
                "url": request.url_rule.rule,
                "time_spent": time_end - time_start,
            }))
        except Exception as e:
            raise
        return ret
    return wrapper

@app.route('/whitelist.json')
@perf_logging
def whitelist():
    ...
```

[slide]
# 四，自建方案(基于Sentry客户端SDK) {:&.flexbox.vleft}
## 利用Flask的信号钩子，Sentry官方调用示例如下： 

```python
import flask

import sentry_sdk
from sentry_sdk.integrations.flask import FlaskIntegration
sentry_sdk.init(
    dsn="https://269190fd927b40ec15195a4b1524424b@sentry.io/1272139",
    integrations=[FlaskIntegration()]
)

app = Flask(__name__)
```

[slide]
# 四，自建方案(基于Sentry客户端SDK) {:&.flexbox.vleft}
## 增加对pv的监控

```python
import sentry_sdk
from sentry_sdk.integrations.flask import FlaskIntegration
import weakref
from flask.signals import request_started
from flask import _request_ctx_stack
class FlaskIntegrationDiy(FlaskIntegration):
	@staticmethod
	def setup_once():
		request_started.connect(catch_request_started)
		super(FlaskIntegrationDiy, FlaskIntegrationDiy).setup_once()
def catch_request_started(sender, **kwargs):
    hub = sentry_sdk.hub.Hub.current
    integration = hub.get_integration(FlaskIntegrationDiy)
    if integration is not None:
    	weak_request = weakref.ref(_request_ctx_stack.top.request)
    	hub.capture_event({"transaction": weak_request().environ['PATH_INFO']})
sentry_sdk.init(
    dsn="https://testdemo@10.0.0.11/100",
    integrations=[FlaskIntegrationDiy()]
)
```

[slide]
# 五，待完善的地方 {:&.flexbox.vleft}
## 监控pv响应时间
## 监控资源：数据库、缓存
## 汇总端的并发性能问题
## Sentry SDK的问题(内存泄漏)
## 业务埋点数据

[slide]
# Thanks
