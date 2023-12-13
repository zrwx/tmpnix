{
  enable = true;

  extraConfig = ''
    set selection-clipboard clipboard
    set adjust-open width
    #set recolor true
    set guioptions ""
    set first-page-column 1:1
    set inputbar-fg "#FFFFFF"
    set inputbar-bg "#000000"
    set statusbar-home-tilde true
    set index-bg "#000000"
    set index-active-fg "#000000"
    set index-fg "#FFFFFF"
    set index-active-bg "#FFFFFF"
    set statusbar-h-padding 0
    set statusbar-v-padding 0
    set page-padding 0

    map r reload
    map R rotate
    # map <C-i> zoom in
    # map <C-o> zoom out
    map u scroll half-up
    map d scroll half-down
    map D toggle_page_mode
    map p print
  '';
}