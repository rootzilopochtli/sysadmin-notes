# Load Balancing with HAProxy

Using HAProxy for a load-balanced web service.

---

## HAProxy Server

### Installation

Update OS

```
# dnf clean all && dnf update
```

Install haproxy

```
# dnf install haproxy
```

### Configure service

Use [`haproxy.cfg.template`](https://github.com/CursoIntegralLinux/mai-notes/blob/main/haproxy/haproxy.cfg.template) as haproxy config file.

```
# cp haproxy.cfg.template /etc/haproxy/haproxy.cfg
```

**Note: Replace the IP's of the webservers:**

```
...
backend app
    balance     roundrobin
    server  web1 192.168.0.21:80 check
    server  web2 192.168.0.22:80 check
```

### Enable service

```
# systemctl enable --now haproxy
```

**Note: Fix `selinux` if needed**

* Enable booleans

```
# setsebool -P nis_enabled 1
# setsebool -P haproxy_connect_any 1
```

* Enable port

```
# semanage port -a -t http_port_t -p tcp 150
```


## Web Service Node

### Installation

Update OS

```
# dnf clean all && dnf update
```

Install httpd

```
# dnf install httpd
```

Enable service

```
# systemctl enable --now httpd
```

### Configure service

Use [`index.html.template`](https://github.com/CursoIntegralLinux/mai-notes/blob/main/haproxy/index.html.template) as index file.

```
# cp index.html.template /var/www/html/index.html
```

**Note: Replace the _hostname_ of the webservers:**

```
...
<h1>
Hello from [hostname]
</h1>
...
```

## Test service

Use `curl` to test the load balancing of web servers

```
# curl localhost
<html>
<head><title>Apache is running!</title></head>
<body>
<h1>
Hello from webserver1
</h1>
</body>
</html>

# curl localhost
<html>
<head><title>Apache is running!</title></head>
<body>
<h1>
Hello from webserver2
</h1>
</body>
</html>
```

## References
- [Types of Load Balancing](https://es.wikipedia.org/wiki/Equilibrador_de_carga)
