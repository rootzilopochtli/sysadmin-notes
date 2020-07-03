# Barry Allen Notes

## What's this about?  
Tips, hacks and quick short commands like the flash
---

- **Check for read only filesystem**
```
awk '$4~/(^|,)ro($|,)/' /proc/mounts
```

- **Find the 10 heaviest directories**
```
ls | xargs du -sk | sort -n | awk '{ print $2 }' | xargs du -sh | tail -10
```

### nmap

- Scan network range
```
nmap -SP 192.168.0.0/24
```

### bashtop

```
git clone https://github.com/aristocratos/bashtop.git
```

![bashtop](https://github.com/rootzilopochtli/sysadmin-notes/blob/master/images/bashtop.png?raw=true)
