# Functions
function sshadd(){
  if ! ssh-add -l | grep ivan.waginger@gmail.com 2>&1 /dev/null; then
    ssh-add /home/kiwwiaq/Documents/ssh_kluce/iwaginger_ed25519.key
  fi
}
