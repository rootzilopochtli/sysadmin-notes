# tlog Notes

`tlog` is a terminal I/O recording and playback package suitable for
implementing _centralized user session recording_.

## Code

- tlog project: [github](https://github.com/Scribery/tlog)

## Packages

- [Download](https://github.com/Scribery/tlog/releases)

### Compiling for use in RHEL

- Download the latest `.tar.gz` from [releases](https://github.com/Scribery/tlog/releases)

- Install the dependency packages
```
yum -y install json-c-devel systemd-devel libcurl-devel
```

- Configure and make
```
./configure
make && make install
```

### Using tlog

- Record a session
```
tlog-rec --writer=file --file-path=tlog.$(date +%d%m%Y_%H%M).log
```

- Play a record
```
tlog-play --reader=file --file-path=tlog.[date].log
```

**NOTE**: If you want to change the _playback speed_, use the **s** option plus the multiple in _NUMBER_, for example:
```
tlog-play --reader=file --file-path=tlog.[date].log -s 2
```
