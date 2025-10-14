git-keeper 1 "September 2025" git-keeper "User Manual"
=====================================================

# NAME

git-keeper - Tracks specified git repos for sysadmins

# SYNOPSIS

**git-keeper** [-h] [--config CONFIG] [--parallel PARALLEL] [--version] {status | commit | update | vcs | ls | diff | motd | help} [<args>...]

# DESCRIPTION

git-keeper is a tool to help sysadmins track the status of specified git repositories on a server. It checks if the repositories are clean (no uncommitted changes) and if they are up-to-date with their remote counterparts.

git-keeper also provides an optional systemd service and timer, to help display status information in the message of the day (MOTD). This is useful for reminding sysadmins to clean and update their repositories.

# CONFIGURATION

Please make sure:

1. Users running git-keeper have read and write access through `sudo` (`NOPASSWD` is **required**) for git repositories specified in the config file.
    - **git-keeper is aware of `sudo` as it uses `SUDO_USER` environment variable to determine which user to run git commands as**. Other elevated privilege methods (like `su`, `doas`, `pkexec`, `run0`, etc.) are not supported.
2. Repositories needed to be pushed to remote are set up with **SSH** deploy keys. git-keeper would NOT try pushing repos using HTTPS.
    - Read **EXAMPLE: SSH DEPLOY TRICKS** below for details, especially if you are using GitHub.
3. It's recommended to set up alias:

    ```bash
    alias gitkp="git-keeper vcs ."
    ```

    So you could use `gitkp` same as how you use `git` before.

The file `/etc/git-keeper.conf` is used to specify which git repositories to track. It is in INI format:

```ini
[repo_name]
path = /path/to/repo
```

If you need to specify a user to run git commands, you can add a `user` field. By default, git-keeper uses the owner of the specified folder, so usually you do not need to set this.

```ini
[repo_name]
path = /path/to/repo
user = someuser
```

Upon first run, git-keeper would ask for your email and use your username as name, unless `~/.gitconfig` or `~/.git-keeper.conf` is already configured.

The MOTD service and timer would only be enabled if `/etc/git-keeper.conf` exists.

# EXAMPLE: CHECK SYSTEM REPOS

As sysadmin, you could check system status with:

```bash
git-keeper status
```

For repos not clean, you could inspect changes with:

```bash
git-keeper diff repo_name
```

Then you could commit changes with:

```bash
git-keeper commit repo_name
```

Finally, you could update repos with:

```bash
git-keeper update repo_name
# or update all repos
git-keeper update
```

# EXAMPLE: OPERATE ON CURRENT REPO

git-keeper supports `.` as a special name to represent the current directory repo if it exists in config file:

```bash
git-keeper status .
git-keeper diff .
git-keeper commit .
git-keeper update .
```

Also, the `vcs` command allows you to run any git command on specified repos:

```bash
git-keeper vcs . diff HEAD~1 HEAD
```

# EXAMPLE: SSH DEPLOY TRICKS

For your information, you can create a deploy key for each repository with following steps:

1. Create a SSH key pair inside the `.git` directory of the repository.

    ```bash
    cd .git
    # RSA key pair
    ssh-keygen -f ./id_rsa -t rsa -b 4096 -N ""
    # or ED25519 key pair
    ssh-keygen -f ./id_ed25519 -t ed25519 -N ""
    ```

2. Update `.git/config` like this:

    ```ini
    [core]
        # ...
        # RSA key pair
        sshCommand = ssh -i .git/id_rsa
        # or ED25519 key pair
        sshCommand = ssh -i .git/id_ed25519
    ```

3. Add public key (`id_rsa.pub` or `id_ed25519.pub`) to the repository's deploy keys.

# HISTORY

October 2025, Originally compiled by Keyu Tao (taoky@ustclug.org)
