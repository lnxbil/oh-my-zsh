###############################################################################
#            FILE: lnxbil.zsh-theme
#     DESCRIPTION: oh-my-zsh theme file with GIT and SVN look and feel
#          AUTHOR: Andreas Steinel <A.Steinel@gmail.com>
#         VERSION: 1.0
#      SCREENSHOT: coming soon
# ACKNOWLEDGEMENT: Theme based on the following other themes. Great work guys!
#                   - bira
#                   - gentoo
#                   - jnrowe
#                   - juanghurtado
#                   - wedisagree
#                   - maran
###############################################################################

function _plugin_present
{
    for plugin ($plugins); do
        if [ $plugin = $1 ]
        then
            return 0
        fi
    done
    return 1
}

# user information (green for normal user, red for system user)
local user_host='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})%n@%m%{$reset_color%}'

# current directory ($HOME abbreviated as ~)
local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'

# Load and show the RVM prompt if plugin present
if _plugin_present "rvm"
then
    # This only shows the RVM prompt if rvm-prompt return something useful
    # and not an empty string
    function show_rvm_prompt
    {
        rvm_ruby_prompt=$(rvm-prompt i v g)
        if [ "$rvm_ruby_prompt" != "" ]
        then
            echo "%{$fg[red]%}‹${rvm_ruby_prompt}›%{$reset_color%}"
        else
            echo ''
        fi
    }
    local rvm_ruby='$(show_rvm_prompt)'
else
    local rvm_ruby=''
fi

# Load and show the GIT prompt if plugin present
if _plugin_present "git"
then
    local git_branch='$(git_prompt_info)$(git_prompt_short_sha)%{$reset_color%}'
    local git_status='$(git_prompt_status)%{$reset_color%}'
else
    local git_branch=''
    local git_status=''
fi

# Load and show the SVN prompt if plugin present
if _plugin_present "svn"
then
    local svn_branch='$(svn_prompt_info)%{$reset_color%}'
    local svn_status='$(svn_prompt_status)%{$reset_color%}'
else
    local svn_branch=''
    local svn_status=''
fi

# Load and show the BATTERY prompt if plugin present
if _plugin_present "battery"
then
    local battery_status='$(battery_pct_prompt) with $(battery_time_remaining)'
else
    local battery_status=''
fi


# Get the return status of the last command
local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})%?%{$reset_color%}"

# The prompt character
local p="%{$fg[red]%}»%{$reset_color%}"

PROMPT="\
${user_host} ${rvm_ruby} ${git_branch}${svn_branch}
${current_dir} [$ret_status] ${git_status}${svn_status} %B${p}%b "
RPROMPT="${battery_status} %{$fg[white]%}[%{$fg[cyan]%}%D %*%{$fg[white]%}]%{$reset_color%}"

# Format for git_prompt_info
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}ⓐ  "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}ⓜ  "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}ⓧ  "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}ⓡ  "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}ⓤ  "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}ⓣ  "

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[red]%}[%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg[red]%}]%{$reset_color%}"

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}"


# SVN Forwarding on GIT-Status
ZSH_THEME_SVN_PROMPT_PREFIX="%{$fg[yellow]%}svn:("
ZSH_THEME_SVN_PROMPT_SUFFIX=$ZSH_THEME_GIT_PROMPT_SUFFIX
ZSH_THEME_SVN_PROMPT_ADDED=$ZSH_THEME_GIT_PROMPT_ADDED
ZSH_THEME_SVN_PROMPT_MODIFIED=$ZSH_THEME_GIT_PROMPT_MODIFIED
ZSH_THEME_SVN_PROMPT_DELETED=$ZSH_THEME_GIT_PROMPT_DELETED
ZSH_THEME_SVN_PROMPT_RENAMED=$ZSH_THEME_GIT_PROMPT_RENAMED
ZSH_THEME_SVN_PROMPT_UNMERGED=$ZSH_THEME_GIT_PROMPT_UNMERGED
ZSH_THEME_SVN_PROMPT_UNTRACKED=$ZSH_THEME_GIT_PROMPT_UNTRACKED
ZSH_THEME_SVN_PROMPT_DIRTY=$ZSH_THEME_GIT_PROMPT_DIRTY
ZSH_THEME_SVN_PROMPT_CLEAN=$ZSH_THEME_GIT_PROMPT_CLEAN
