
#############################################################
### ZSH PROMPT


# For the prompt stuff, check out https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# For the colors, check out https://www.ditig.com/256-colors-cheat-sheet


# 1 line prompt with full path
#export PS1="%F{214}%m%F{015} %F{039}%~ %F{015}%% "

# 1 line prompt with small concise path
#export PS1="%F{214}%m%F{015} %F{039}%1~ %F{015}%% "

# 1 line prompt with small concise path w/ arrow instead of zsh's % (requires font w/ ligatures)
#export PS1="%F{214}%m%F{015} %F{039}%1~ -> %F{015}"

# 1 line prompt with small concise path and colored %/$ sign 
#export PS1="%F{214}%m%F{015} %F{039}%1~ %F{007}%% %F{015}"

# 1 line prompt with just compact path + purple prompt
#export PS1="%F{147}%1~ $ %F{255}%b"

# 1 line prompt with just compact path + any color prompt
#export PS1="%F{226}%1~ $ %F{255}%b"

# 1 line prompt with just compact path + less colors
export PS1="%F{247}%1~ $ %F{255}%b"

# 1 line prompt with custom lambda marking and gold/purple colors
#export PS1="%F{214}λ%F{015} %F{111}%1~ %B$ %F{015}%b"

# 1 line simple and very concise path
#export PS1="%F{214}%F{015}%F{039}%1~ %F{007}%% %F{015}"

# 1 line prompt with semi-small concise path (like 2 folder names at most)
#export PS1="%F{214}%m%F{015} %F{039}%2~ %F{015}%% "

# 2 line prompt
#export PS1="%F{214}%m%F{015} %F{039}%~ %F{015}"$'\n'"%F{214}->%F{015} "