[slide]
# 《创业就是要细分垄断》读记
## 2019-01-16
<style>
.flexbox.vleft {justify-content:normal !important;}
</style>

[slide]
# 作者介绍 {:&.flexbox.vleft}
## 

<div class="columns3">
<img src="src/kaifu.jpg" height="200">
<img src="src/wanghua.jpg" height="200">
<img src="src/fusheng.jpg" height="200">
</div>
<div class="columns3">
<pre>

李开复
创新工场的董事长</pre>
<pre>

汪华
创新工场的创始人</pre>
<pre>

傅盛
猎豹移动（原金山网络）CEO</pre>
</div>

[slide]
# 目录 {:&.flexbox.vleft}
## 1. 为什么要细分垄断
## 2. 李开复谈互联网的幂定律
## 3. 汪华的创业经验
## 4. 傅盛火车头三部曲

[slide]
# 1. 为什么要细分垄断 {:&.flexbox.vleft}
## 为什么要细分垄断
* 创业公司只有有限的钱和资源，如果没有进展只能活一两年，所以只能创造小垄断
* 真正能让创业者有机会的在于，传统巨头没有看清趋势给了你先机，或者看清了也办法采纳和直接使用（极限验证）。

[slide]
# 2. 李开复谈互联网的幂定律 {:&.flexbox.vleft}
## 互联网产品符合幂定律
* 安卓和苹果系统占智能手机系统98%
* 电商领域，淘宝是其它所有电商之和

## 移动IM，微信一骑绝尘
人才符合幂定律。在工业社会，一个最好的，最有效率的个人能多生产20%～30%的产品。但是在信息社会中，一个好的人才，能够比一般人员多做出500%甚至1000%的工作。

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
