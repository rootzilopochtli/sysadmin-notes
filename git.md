# Git Notes

>_Some notes about git, because I always forget it._

---
## Links and references

- [Git Docs](https://git-scm.com/doc)
- [Git Docs - Book](https://git-scm.com/book/en/v2)
- [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- [Markdown cheatsheet online](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf)
- [2FA give problems when pushing to GitHub](https://stackoverflow.com/questions/40950497/2fa-give-problems-when-pushing-to-github)

---

- Local configuration
  - User settings
  ```
  git config --global user.name "username"
  git config --global user.email user@your.mail
  ```
  - Store username and password
  ```
  git config --global credential.helper store
  git pull
  ```
  - Authenticate on GitHub
  ```
  ssh -T git@github.com
  ```

- Create local repository
```
mkdir my-repo && cd my-repo
git init
```

- Rename master branch
```
git branch -m master main
```

- Add all files
```
git add .
```

- Add and commit
```
git commit -am "Commit message"
```

- Add remote repository
```
git remote add origin https://github.com/AlexCallejas/my-repo.git
```
**NOTE: As a best practice, the local and remote repo should have the same name as the directory created.**

- Check remotes
```
git remote -v
```

- Check logs on single line track
```
git log --oneline --graph
```

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

- Switch to a remote branch
  - Get a list of all branches from the remote
  ```
  git pull
  ```
  - Switch to the branch
  ```
  git checkout --track origin/remote-branch-name
  ```

- Adding changes to repo
```
git add [file(s) or directory]
```

- Save changes to repo (w/comment)
```
git commit -m "text describing the change"
```

**NOTE: If are required to run pre-commit scripts before commit to push:**
<pre>
<i>Install pre-commit scripts on the root of the repo</i>
$ pre-commit install
<br>
<i>Pre-commit scripts will be executed as output from the commit</i>
$ git commit -m '<i>review-lab-content.xml</i> file added'
Check for merge conflicts................................................<b>Passed</b>
Executable text files have shebangs..................(<i>no files to check</i>)<b>Skipped</b>
Trim Trailing Whitespace.................................................<b>Passed</b>
Check Xml................................................................<b>Passed</b>
Check Yaml...........................................(<i>no files to check</i>)<b>Skipped</b>
Invalid Tag Combinations Check...........................................<b>Passed</b>
<i>...</i>
<br>
<i>If you want to run the pre-commit scripts by hand, use</i>
$ pre-commit run --all-files
</pre>

- To push the branch to make merge with master
```
git push -u origin acalleja/fixch08s01
```

- Update branch from master
  - merge (this creates an extra commit for merge)
    ```
    git fetch
    git pull --all
    git checkout acalleja/fixch02s01
    git merge master
    git push origin acalleja/fixch02s01
    ```
  - rebase
    ```
    git fetch
    git rebase origin/master
    ```

    - rebase → resolve conflicts with strategy and force merge avoiding a potential collision with an upstream change
      ```
      git rebase -X theirs origin/master
      git push --force-with-lease origin acalleja/fixch02s01
      ```

- Commit history
  - Basic
    ```
    git log
    ```
  - Last 2 commits
    ```
    git log -2
    ```
  - Formatting output
    ```
    git log -2 --pretty=format:"%h - %an, %ar : %s"
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

- Create a pull request in GitHub (Upstream collaboration)
  - Fork a repo

  - Clone the repo

  - Create a new branch
    ```
    git checkout -b new_branch
    ```

  - Create a new remote for the <i>upstream</i> repo
    ```
    git remote add upstream https://github.com/upstream_user/repo_forked
    ```

  - Perform changes to the code (add and commit)

  - Push your branch
    ```
    git push -u origin new_branch
    ```

    **NOTE: If authentication is required, enter the corresponding values:**
    <pre>
    Username for 'https://github.com': <i>username</i>
    Password for 'https://<i>username</i>@github.com': <i>Personal access token</i>
    </pre>

  - The output indicates the link to generate the pull request
    ```
    remote:
    remote: Create a pull request for 'new_branch' on GitHub by visiting:
    remote:      https://github.com/rootzilopochtli/repo_forked/pull/new/new_branch
    remote:
    ```

  - On GitHub link, click on **Compare & pull request** button, and **Create pull request** to send the PR to upstream.
  
  - This allows the repo's maintainers to review your contribution. From here, they can merge it if it is good, or they may ask you to make some changes.
