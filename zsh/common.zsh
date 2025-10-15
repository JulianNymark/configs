alias ls='ls -G --color'
alias ll='ls -lAh'
alias la='ls -lAhrt'

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

alias npms="cat package.json | jq .scripts"
alias npmd="cat package.json | jq '.|{dependencies: .dependencies, devDependencies: .devDependencies}'"
alias yarns=npms
alias yarnd=npmd

alias c='pwd | pbcopy'
alias p='cd $(pbpaste)'

alias fix_yarn='yarn clean ; rm -r node_modules .yarn/cache && yarn'
alias grrh='git reset --hard origin/HEAD'

alias vim='nvim'
alias v='nvim'
alias n='nvim'
alias nvimswpdel='rm ~/.local/state/nvim/swap/*'

alias rga='rg --no-ignore-vcs' # rg "all"

alias gd_export='/Applications/Godot.app/Contents/MacOS/Godot --export-debug Web ./dist/index.html'

alias activate='source .venv/bin/activate'

alias nvim_minimal='nvim -u ~/Repos/configs/nvim/minimal.lua'

# split strings
s () {
  node -r 'fs' -e "console.log(fs.readFileSync(process.stdin.fd).toString().split('$1' || ' '))" 
}

c_ip () {
  ifconfig | grep 'inet ' | cut -d' ' -f2 | tail -n 1 | pbcopy
}

my_ip () {
  local ip=$(ifconfig | grep 'inet ' | cut -d' ' -f2 | tail -n 1);
  echo $ip | qrencode -t ANSIUTF8;
  echo $ip;
}

my_age () {
  local time=$(($(date -vDecm -v06d -v1991y +%s) - $(date +%s)));
  printf 'I am %d years %d days old\n' $(($time/60/60/24/365 * -1)) $(($time/60/60/24%365 * -1));
}

yarna () {
  local filter="$1"
  rg --files --glob package.json | xargs -I {} jq -r \
    '.scripts? 
     | with_entries(select(.key | test(":")))?
     | select(. | length > 0)
     | { (input_filename): . }' {} \
  | jq -s 'add' \
  | jq --arg filter "$filter" '
      if $filter == "" then .
      else with_entries(
        .value |= with_entries(
          select((.key + " " + .value) | test($filter))
        )
      ) | with_entries(select(.value != {}))
      end'
}

yt-sample () {
  yt-dlp -x --audio-format mp3 $1 -o $2
}

ffmpeg_resize () {
  local input="$1"
  local target_size_mb="$2"
  local output="$3"

  if [[ -z "$input" || -z "$target_size_mb" ]]; then
    echo "Usage: compress_video input_file target_size_MB [output_file]"
    return 1
  fi

  if [[ ! -f "$input" ]]; then
    echo "Error: Input file not found: $input"
    return 1
  fi

  # Default output name if not provided
  if [[ -z "$output" ]]; then
    local base="${input:t:r}"  # filename without path or extension
    output="${base}-${target_size_mb}mb.webm"
  fi

  local extension="${output:e:l}"  # get lowercase extension
  local codec_v codec_a format audio_bitrate_kbps

  # Choose codecs and container based on output extension
  if [[ "$extension" == "mp4" ]]; then
    codec_v="libx264"
    codec_a="aac"
    format="mp4"
    audio_bitrate_kbps=128
  elif [[ "$extension" == "webm" ]]; then
    codec_v="libvpx-vp9"
    codec_a="libopus"
    format="webm"
    audio_bitrate_kbps=96
  else
    echo "Error: Unsupported output format '$extension'. Use .mp4 or .webm"
    return 1
  fi

  # Convert MB to bits
  local target_size_bits=$(( target_size_mb * 1024 * 1024 * 8 ))

  # Get video duration
  local duration
  duration=$(ffprobe -v error -select_streams v:0 -show_entries format=duration \
            -of default=noprint_wrappers=1:nokey=1 "$input")

  if [[ -z "$duration" ]]; then
    echo "Error: Could not get duration from input file."
    return 1
  fi

  local duration_int=$(( ${duration%.*} + 1 ))

  # Calculate video bitrate (subtract audio)
  local target_bitrate_kbps=$(( (target_size_bits / duration_int / 1000) - audio_bitrate_kbps ))

  if (( target_bitrate_kbps < 100 )); then
    echo "⚠️ Warning: Very low target video bitrate (${target_bitrate_kbps} kbps)."
  fi

  echo "🎞️  Compressing '$input' to '$output'"
  echo "📏 Target size: ${target_size_mb}MB"
  echo "⏱ Duration: ${duration_int}s"
  echo "🎥 Video bitrate: ${target_bitrate_kbps} kbps"
  echo "🎧 Audio bitrate: ${audio_bitrate_kbps} kbps"
  echo "📦 Format: ${format}"

  # Run two-pass compression
  ffmpeg -y -i "$input" \
    -c:v "$codec_v" -b:v ${target_bitrate_kbps}k -pass 1 -an -f "$format" /dev/null && \
  ffmpeg -i "$input" \
    -c:v "$codec_v" -b:v ${target_bitrate_kbps}k -pass 2 \
    -c:a "$codec_a" -b:a ${audio_bitrate_kbps}k "$output"

  # Clean up
  rm -f ffmpeg2pass-0.log ffmpeg2pass-0.log.mbtree

  echo "✅ Done: Saved as $output"
}

ffmpeg_resize_old () {
    file=$1
    target_size_mb=$2  # target size in MB
    target_size=$(( $target_size_mb * 1000 * 1000 * 8 )) # target size in bits
    bias=0.7
    length=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file"`
    length_round_up=$(( ${length%.*} + 1 ))
    total_bitrate=$(( $target_size / $length_round_up ))
    video_bitrate=$(( $total_bitrate * bias ))
    ffmpeg -i "$file" -b:v $video_bitrate -maxrate:v $video_bitrate -bufsize:v $(( $target_size / 20 )) -an "${file}-${target_size_mb}mb.webm"
}

ffmpeg_resize_generic_old () {
    file=$1
    target_size_mb=$2  # target size in MB
    target_size=$(( $target_size_mb * 1000 * 1000 * 8 )) # target size in bits
    length=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file"`
    length_round_up=$(( ${length%.*} + 1 ))
    total_bitrate=$(( $target_size / $length_round_up ))
    audio_bitrate=$(( 128 * 1000 )) # 128k bit rate
    video_bitrate=$(( $total_bitrate - $audio_bitrate ))
    ffmpeg -i "$file" -b:v $video_bitrate -maxrate:v $video_bitrate -bufsize:v $(( $target_size / 20 )) -b:a $audio_bitrate "${file}-${target_size_mb}mb.mp4"
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# . "/Users/username/.deno/env"
# export DENO_INSTALL="/Users/juliannymark/.deno"
# export PATH="$DENO_INSTALL/bin:$PATH"

export GIT_EDITOR="nvim -f"
export EDITOR="nvim -f"
export VISUAL="nvim -f"

export GPG_TTY=$(tty)
# ensure that the global git config knows the right gpg program
# $ git config --global gpg.program $(which gpg2)
#
# $ brew install gpg2 gnupg pinentry-mac
# add the following to ~/.gnupg/gpg.conf:
# pinentry-program /opt/homebrew/bin/pinentry-mac

export PATH=$PATH:$HOME/go/bin

source $HOME/.config/zsh/completion.zsh
