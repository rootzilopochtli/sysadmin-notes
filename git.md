# Git Notes

_Some notes about git, because I always forget it._

- Clone repository
```
git clone [repository.git]
```

- List remote branches
```
git branch -a
```

- Create new branch
```
git branch acalleja/fixch08s01
```

- Switch to a branch
```
git checkout acalleja/fixch08s01
```

- Get repo/branch updates
```
git fetch
```

- Adding changes to repo
```
git add [file(s) or directory]
```

- Save changes to repo (w/comment)
```
git commit -m "text describing the change"
```

**NOTE: If are required to run pre-commit scripts before push, use:**
```
pre-commit run --all-files
```

- To push the branch to make merge with master
```
git push -u origin acalleja/fixch08s01
```

- Delete branch
  - Remotely
    ```
    git push origin --delete acalleja/fixch08s01
    ```
  - Locally
    ```
    git branch -d acalleja/fixch08s01
    ```

