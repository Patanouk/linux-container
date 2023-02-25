###################################
##########    LINUX    ############
###################################
FROM ubuntu:22.04 as base

RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq

###################################
############    ZSH    ############
###################################

RUN sh -c "$(curl -L https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -p git \
    -p kubectl \
    -p 'zsh-history-substring-search' \
    -t robbyrussell \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down' \
    -a 'bindkey "^[[A" history-substring-search-up' \
    -a 'bindkey "^[[B" history-substring-search-down' \
    # See https://stackoverflow.com/questions/62931101/i-have-multiple-files-of-zcompdump-why-do-i-have-multiple-files-of-these
    -a 'export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST'

SHELL ["/bin/zsh", "-c"]

# zsh history, we source again to make sure the plugin is installed
RUN  git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
#RUN .  ~/.zshrc

# fzf is a fuzzy command line finder, used to show more than 1 line of git history
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN ~/.fzf/install

# We run zsh once, to make sure gitstatusd is installed
# See https://github.com/romkatv/powerlevel10k/issues/747
RUN echo exit | script -qec zsh /dev/null >/dev/null