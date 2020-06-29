
## 部署

1. 将`jstack.sh`、`cpu_high_load_trigger.sh`放置在宿主机的`/opt/jvm/jstack_dump/`目录;
2. zabbix上增加监控项，当CPU负载较高时，执行`cpu_high_load_trigger.sh`脚本;
3. `jstack.sh`脚本默认执行15次线程dump，每隔1s执行一次(多次采集为了精确定位问题);