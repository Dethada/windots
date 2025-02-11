# Windots

Share the `USERPROFILE` env varible with WSL.
```powershell
setx WSLENV "USERPROFILE/p"
```

Clone this repo
```bash
git clone --bare https://github.com/Dethada/windots.git $USERPROFILE/.dotfiles
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
