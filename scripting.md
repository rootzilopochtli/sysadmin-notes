# Scripting

Some tips for bash scriptings

## stat

```
#!/bin/bash
USER=$(stat -c '%U' /path/to/your/file)
```

- The <code>stat</code> commands allows for several output formats, for handling users/groups/permissions these are the most important:

```
%u  user ID of owner
%U  user name of owner
%g  group ID of owner
%G  group name of owner
%a  access rights in octal
%A  access rights in human readable form
%C  SELinux security context string
```
