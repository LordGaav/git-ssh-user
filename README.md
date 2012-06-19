Set of script to facilitate automatic setting of GIT_AUTHOR_NAME and 
GIT_AUTHOR_EMAIL based on the SSH fingerprint of the currently logged
in user.

The set-git-author script should be called when the user logins in using
and SSH key. It then checks the SSH key fingerprint which is available
in ssh-add agains a list in /etc/gitusers, and sets the GIT_AUTHOR_\*
environment variables based on the found values. This file should contain
three pipe seperated values per line:

```
aa:bb:cc:dd:ee:ff:11:22:33:44:55:66:77:88:99:00|Nick Douma|n.douma@nekoconeko.nl
```

If the provided git pre-commit hook is activated, it checks if the user
that is trying to commit has a valid SSH key in ssh-add. If so, it checks
if the author of the commit matches the committer, which signifies that
the first script did not change the GIT_AUTHOR_\* environment variables
on login for some reason. It then stops the commit and provides the user
with the necessary steps to properly set his author info.
