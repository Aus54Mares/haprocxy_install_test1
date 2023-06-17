


mkdir /usr/local/haproxy1.7.9/etc 
cd  /usr/local/haproxy1.7.9/etc
vi  /usr/local/haproxy1.7.9/etc/haproxy.cfg   

#全局配置
global
    #设置日志
    log 127.0.0.1 local0 info
    #当前工作目录
    chroot /usr/local/haproxy1.7.9
    #用户与用户组
    user haproxy
    group haproxy
    #运行进程ID
    uid 149
    gid 149
    #守护进程启动
    daemon
    #最大连接数
    maxconn 4096

#默认配置
defaults
    #应用全局的日志配置
    log global
    #默认的模式mode {tcp|http|health}
    #TCP是4层，HTTP是7层，health只返回OK
    mode tcp
    #日志类别tcplog
    option tcplog
    #不记录健康检查日志信息
    option dontlognull
    #3次失败则认为服务不可用
    retries 3
    #每个进程可用的最大连接数
    maxconn 2000
    #连接超时
    timeout connect 5s
    #客户端超时
    timeout client 120s
    #服务端超时
    timeout server 120s

#绑定配置
listen  rabbit_clus1
        # 这是 haproxy对外提供的端口号；不是rabbitmq自己的端口号；
        bind 192.168.11.6:5672
        #配置TCP模式
        mode tcp
        #简单的轮询
        balance roundrobin
        #RabbitMQ集群节点配置
        server node1 192.168.11.7:5672 check inter 5000 rise 2 fall 3 weight 1
        server node2 192.168.11.8:5672 check inter 5000 rise 2 fall 3 weight 1
        server node3 192.168.11.9:5672 check inter 5000 rise 2 fall 3 weight 1

#haproxy监控页面地址
listen monitor 
        bind 0.0.0.0:18102
        mode http
        option httplog
        stats enable
        stats uri /rabbitmq-stats
        stats refresh 5s
        # 密码
        stats auth admin:aa11
        stats admin if TRUE
        
        
        
        
        
