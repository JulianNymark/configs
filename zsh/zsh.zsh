# split strings
s () {
  node -r 'fs' -e "console.log(fs.readFileSync(process.stdin.fd).toString().split('$1' || ' '))" 
}

# new git project setup (using bare repos & worktrees)
# USAGE: repo githubuser/reponame
#
# new structure becomes:
# project
#   ├── .bare
#   ├── feature
#   └── main
alias gclb='f(){ git clone --bare "$@" .bare }; f'
alias repo='f(){
  mkdir -p "$HOME/Repos/$1";
  cd "$HOME/Repos/$1";
  gclb "git@github.com:$1.git";
  echo "gitdir: ./.bare" > .git;
  git worktree add main;
}; f'

# my_ip = TBD

my_age () {
  local time=$(($(date -vDecm -v06d -v1991y +%s) - $(date +%s)));
  printf 'I am %d years %d days old\n' $(($time/60/60/24/365 * -1)) $(($time/60/60/24%365 * -1));
}

alias npmsa="rg --files --glob package.json | xargs -I {} jq -r '.scripts? | with_entries(select(.key | test(\":\")))? | select(. | length > 0) | {key: input_filename, value: .}' {} | jq -s 'from_entries'"
