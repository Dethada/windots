# Windots

Share the `USERPROFILE` env varible with WSL.

> Note if you are using wezterm, this [will be overwritten by wezterm](https://wezterm.org/config/lua/config/term.html), currently I just set USERPROFILE mannually in my shell config as a work around.
```powershell
setx WSLENV "USERPROFILE/p"
```

Clone this repo
```bash
git clone --bare https://github.com/Dethada/windots.git $USERPROFILE/.dotfiles
```

If using wezterm
```bash
export USERPROFILE='/mnt/c/<user>'
```

Add the following to your `.zshrc` or your respective shell config and source it.
```bash
alias windots='/usr/bin/git --git-dir=$USERPROFILE/.dotfiles/ --work-tree=$USERPROFILE'
```

Checkout the files
```bash
# ignore untracked files
windots config --local status.showUntrackedFiles no

windots checkout
```
