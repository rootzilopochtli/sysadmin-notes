# Barry Allen Notes

## What's this about?  

_Tips, hacks and quick short commands like [the flash](https://www.dccomics.com/characters/the-flash)._

- [Markdown cheatsheet](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf).

- [How to install JBoss on CentOS7](https://gist.github.com/darkaxl/d03da9585aabe10e14df29aa912155d8)

- **Check for read only filesystem**
```
awk '$4~/(^|,)ro($|,)/' /proc/mounts
```

- **Find the 10 heaviest directories**
```
ls | xargs du -sk | sort -n | awk '{ print $2 }' | xargs du -sh | tail -10
```

- **Enable service/port in firewalld**
```
firewall-cmd --permanent --add-port={22/tcp,80/tcp,443/tcp,8080/tcp,8443/tcp,9990/tcp,9999/tcp}
firewall-cmd --permanent --add-service={http,https,ssh}
systemctl restart firewalld.service

firewall-cmd --permanent --zone=public --list-all
```

### nmap

- Scan network range
```
nmap -sP 192.168.0.0/24
```

### bashtop

```
git clone https://github.com/aristocratos/bashtop.git
```

![bashtop](https://github.com/rootzilopochtli/sysadmin-notes/blob/master/images/bashtop.png?raw=true)
