{
  enable = true;

  extraConfig = ''
    set -g prefix M-space

    # allow sending the prefix to other apps (press twice)
    bind M-space send-prefix
    
    set -g mode-keys vi
    set -g mouse on
    set -g escape-time 0
    set -g history-limit 100000
    
    # Rather than constraining window size to the maximum size of any client
    # connected to the *session*, constrain window size to the maximum size of any
    # client connected to *that window*. Much more reasonable.
    # Combined with using
    #    `tmux new-session -t alreadyExistingSessionName -s newSessionName`
    # we can have two views into the same session viewing different windows
    set -g aggressive-resize on
    
    # set -g default-terminal "tmux-256color"
    set -g default-terminal "alacritty"
    # set -g set-titles off
    # set -g set-titles on
    set -g focus-events on
    
    # set -g status-style fg=darkgrey,dim,bg=black
    set -g status-style fg=black,bg=white
    set -g pane-active-border-style fg=darkgrey
    set -g window-status-current-style fg=black,bold,bg=grey
    set -g message-style fg=yellow,blink,bg=black
    
    # set -gw xterm-keys on # for vim
    # set -gw monitor-activity on
    # set -g terminal-overrides 'xterm*:smcup@:rmcup@'
    
    # status configuration
    # set -g status off
    set -g status-justify left
    set -g status-interval 1
    set -g status-left ""
    set -g status-right '#(date +%Y-%m-%d\ %R)'
    set -g visual-activity off
    
    # 1-indexed window/pane indices:
    set -g base-index 1
    set -g pane-base-index 1
    
    set -g automatic-rename
    
    # TODO: pane switcher with fzf
    bind Space list-panes
    bind Enter break-pane
    
    # jump to last window/pane
    bind -n M-s last-pane
    bind -n M-tab last-window
    
    # jump to last pane if there is another pane, else last window
    bind -n M-u \
      if-shell '[[ "$(tmux list-panes | wc -l)" -gt 1 ]]' \
        'last-pane' \
        'last-window'
    
    # window navigation
    bind -n M-h previous-window
    bind -n M-l next-window
    bind -n M-k previous-window
    bind -n M-j next-window
    
    # pane navigation
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R
    bind -n M-H select-pane -L
    bind -n M-J select-pane -D
    bind -n M-K select-pane -U
    bind -n M-L select-pane -R
    
    # pane resizing
    bind -r C-h resize-pane -L
    bind -r C-j resize-pane -D
    bind -r C-k resize-pane -U
    bind -r C-l resize-pane -R
    
    bind -n M-n new-window
    bind -n M-c new-window
    bind -n M-C new-window -c "#{pane_current_path}"
    bind -n M-N new-window -c "#{pane_current_path}"
    # bind -n M-\; command-prompt
    bind -n 'M-;' new-window
    
    bind M-r rotate-window
    bind r source-file $TMUXRC
    unbind d
    bind d kill-pane
    
    
    # toggle status
    bind b set status
    
    # bind F new-window \; send-keys -R "C-l" f Enter
    bind R new-window \; send-keys -R "C-l" r Enter
    bind c new-window
    bind C new-window -c "#{pane_current_path}"
    
    # window splitting
    # bind '%' split-window -v -c "#{pane_current_path}"
    # bind '"' split-window -h -c "#{pane_current_path}"
    bind -n 'M-\' split-window -v -c "#{pane_current_path}"
    bind -n 'M-|' split-window -h -c "#{pane_current_path}"
    
    # bind '&' new-window 'tmux capture-pane -t:- -Jp -S- | nvim -c ":normal G" -'
    # bind -n M-v new-window 'nvim -c ":r !tmux capture-pane -t:- -Jp -S-" -c ":normal G"'
    
    # enter copy mode
    bind -n M-[ copy-mode
    bind 'v' copy-mode
    bind -n M-v copy-mode
    
    # don't copy selection and cancel copy mode on drag end event:
    unbind -T copy-mode-vi MouseDragEnd1Pane
    # mouse scrolling scrolled rows per tick from default 5 to 2
    bind -T copy-mode-vi WheelUpPane send -X -N 2 scroll-up
    bind -T copy-mode-vi WheelDownPane send -X -N 2 scroll-down
    bind -T copy-mode-vi v send -X begin-selection
    bind -T copy-mode-vi r send -X rectangle-toggle
    bind -T copy-mode-vi y send -X copy-pipe
    # bind -T copy-mode-vi y send -X copy-selection
    # bind -T copy-mode-vi Escape send -X cancel
    
    # List of plugins
    # set -g @plugin 'tmux-plugins/tpm'
    # set -g @plugin 'tmux-plugins/tmux-sensible'
    # set -g @plugin 'sainnhe/tmux-fzf'
    
    # run '$XDG_CONFIG_HOME/tmux/plugins/tpm/tpm'
  '';
}