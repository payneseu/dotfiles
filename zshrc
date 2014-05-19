
autoload colors
colors

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
eval $color='%{$fg[${(L)color}]%}'
(( count = $count + 1 ))
done


# right prompt
#RPROMPT=$(echo "$RED%D %T$FINISH")
#PROMPT=$(echo "$CYAN%n[$BLUE%~]$_YELLOW>>$FINISH ")
PROMPT=$(echo "%B$CYAN%n$_YELLOW@$BLUE%<<[%~%<<]$_YELLOW>> $WHITE%b")

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

setopt AUTO_PUSHD	
setopt HIST_IGNORE_SPACE



export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagaced

	

man() {
	env \
		GROFF_NO_SGR=$(printf "1")	\
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}


export PYTHONPATH="/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/"
export DEV_ENV_ROOT=$HOME/android/
export ANDROID_NDK_ROOT="${DEV_ENV_ROOT}/android-ndk-r8c/"
export ANDROID_SDK_ROOT="${DEV_ENV_ROOT}/android-sdk-macosx/"
#export ANDROID_TOOLCHAIN="${DEV_ENV_ROOT}/standalone-toolchain-api14/"
export ANDROID_NDK_HOME="$HOME/android/android-ndk-r8c"



export ANDROID_TOOLCHAIN="$ANDROID_NDK_HOME/standalone-toolchain-api14/"


export ANDROID_HOME="/Users/peli3/android/android-sdk-macosx/"

export PATH=$PATH:"${ANDROID_TOOLCHAIN}/bin/":"${ANDROID_HOME}/platform-tools/"
export PATH="$HOME/bin":$PATH

###====================
#
#autoload -U compinit
#compinit
#zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
#zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
#
#
######################## zsh alias #########################

alias grep='grep --color'
alias mvim='mvim --remote-silent'



###########################  zsh completion ##########################
#
#autoload -U compinit
#compinit

#zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
#zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
#
#autoload -U compinit
#compinit
#
#autoload -U promptinit
#promptinit
#
#setopt correctall
#
#
zstyle ':completion:*' menu select
setopt AUTOLIST
setopt AUTOMENU


autoload -U compinit
compinit


WORDCHARS='*?_-[]~=&;!#$%^(){}<>'


################
#
#http://techanic.net/2012/12/30/my_git_prompt_for_zsh.html
# Adapted from code found at <https://gist.github.com/1712320>.

setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {

  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi

}

# If inside a Git repository, print its branch and state
git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
}

# Set the right-hand prompt
RPS1='$(git_prompt_string)'



#function svn
#{
#	# rebuild args to get quotes right
#	CMD=""
#	for i in "$@"
#	do
#		if [[ "$i" =~ \  ]]
#		then
#			CMD="$CMD \"$i\""
#		else
#			CMD="$CMD $i"
#		fi
#	done
#
#	# pad with spaces to strip --nocol
#	CMD=" $CMD "
#	CMDLEN=${#CMD}
#
#	# parse disabling arg
#	CMD="${CMD/ --nocol / }"
#
#	# check if disabled
#	test "$CMDLEN" = "${#CMD}"
#	NOCOL=$?
#	if [ "$SVN_COLOR" != "always" ] && ( [ $NOCOL = 1 ] || [ "$SVN_COLOR" = "never" ] || [ ! -t 1 ] )
#	then
#		eval $(which svn) $CMD
#		return
#	fi
#
#	# supported svn actions for "status-like" output
#	ACTIONS="add|checkout|co|cp|del|export|remove|rm|st"
#	ACTIONS="$ACTIONS|merge|mkdir|move|mv|ren|sw|up"
#
#	# actions that outputs "status-like" data
#	if [[ "$1" =~ ^($ACTIONS) ]]
#	then
#		eval $(which svn) $CMD | while IFS= read -r RL
#		do
#			if   [[ $RL =~ ^\ ?M ]]; then C="\033[34m";
#			elif [[ $RL =~ ^\ ?C ]]; then C="\033[41m\033[37m\033[1m";
#			elif [[ $RL =~ ^A ]]; then C="\033[32m\033[1m";
#			elif [[ $RL =~ ^D ]]; then C="\033[31m\033[1m";
#			elif [[ $RL =~ ^X ]]; then C="\033[37m";
#			elif [[ $RL =~ ^! ]]; then C="\033[43m\033[37m\033[1m";
#			elif [[ $RL =~ ^I ]]; then C="\033[33m";
#			elif [[ $RL =~ ^R ]]; then C="\033[35m";
#			else C=
#			fi
#
#			echo -e "$C${RL/\\/\\\\}\033[0m\033[0;0m"
#		done
#
#	# actions that outputs "diff-like" data
#	elif [[ "$1" =~ ^diff ]]
#	then
#		eval $(which svn) $CMD | while IFS= read -r RL
#		do
#			if   [[ $RL =~ ^Index:\  ]]; then C="\033[34m\033[1m";
#			elif [[ $RL =~ ^@@ ]]; then C="\033[37m";
#
#			# removed
#			elif [[ $RL =~ ^-\<\<\< ]]; then C="\033[31m\033[1m";
#			elif [[ $RL =~ ^-\>\>\> ]]; then C="\033[31m\033[1m";
#			elif [[ $RL =~ ^-=== ]]; then C="\033[31m\033[1m";
#			elif [[ $RL =~ ^- ]]; then C="\033[31m";
#
#			# added
#			elif [[ $RL =~ ^\+\<\<\< ]]; then C="\033[32m\033[1m";
#			elif [[ $RL =~ ^\+\>\>\> ]]; then C="\033[32m\033[1m";
#			elif [[ $RL =~ ^\+=== ]]; then C="\033[32m\033[1m";
#			elif [[ $RL =~ ^\+ ]]; then C="\033[32m";
#
#			else C=
#			fi
#
#			echo -e "$C${RL/\\/\\\\}\033[0m\033[0;0m"
#		done
#	else
#		eval $(which svn) $CMD
#	fi
#}
#
