{ config, pkgs, lib, ... }:

{
  bash.enable = true;
  yt-dlp.enable = true;
  go.enable = true;
  zsh.enable = true;
  zsh.autocd = false;
  #zsh.cdpath = [ "~/State/Projects/Code/" ];

  btop.enable = true;
  htop.enable = true;
  jq.enable = true;


  #zsh.dirHashes = {
  #  code = "$HOME/State/Projects/Code";
  #  nixos-config = "$HOME/State/Projects/Code/nixos-config";
  #};

  #zsh.plugins = [
  #  {
  #      name = "powerlevel10k";
  #      src = pkgs.zsh-powerlevel10k;
  #      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  #  }
  #  {
  #      name = "powerlevel10k-config";
  #      src = lib.cleanSource ./config;
  #      file = "p10k.zsh";
  #  }
  #];

  zsh.initExtraFirst = ''
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
    fi
    export PATH=$HOME/.npm-packages/bin:$PATH
    export PATH=$NIX_USER_PROFILE_DIR/profile/bin:$PATH
    export PATH=$HOME/bin:$PATH
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Cypress is a dev toom for end-to-end testing
    #export CYPRESS_INSTALL_BINARY=0
    #export CYPRESS_RUN_BINARY=$(which Cypress)

    # Remove history data we don't want to see
    export HISTIGNORE="pwd:ls:cd"

    # Emacs is my editor
    #export ALTERNATE_EDITOR=""
    #export EDITOR="emacsclient -t"
    #export VISUAL="emacsclient -c -a emacs"
    #alias e='emacsclient -t'

    # Enter nix-shell
    #alias s="nix-shell '<nixpkgs>' -A $1"

    # pnpm is a javascript package manager
    #alias pn=pnpm

    # Local global npm packages
    #alias yarn=$HOME/.npm-new-global/bin/yarn

    # bat all the things
    #alias cat=bat

    # Use difftastic, syntax-aware diffing
    #alias diff=difft

    # Always color ls and group directories
    alias ls='ls --group-directories-first --color --human-readable --sort=ext'

    # Weather report in your terminal
    #alias weather='curl http://wttr.in'

    # Some useful docker commands
    #alias docker_clean_images='docker rmi $(docker images -a --filter=dangling=true -q)'
    #alias docker_clean_ps='docker rm $(docker ps --filter=status=exited --filter=status=created -q)'

    '';

  bat = {
    enable = true;
  };
  git = {
    enable = true;
    userName = "Beau Simensen";
    userEmail = "beau@dflydev.com";
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = { 
        excludesfile = "~/.gitignore_global";
        editor = "vim";
        autocrlf = "input";
        safecrlf = false;
      };
    };
    difftastic = {
      enable = true;
    };
  };

  vim = {
    enable = true;
    #plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes vim-startify vim-tmux-navigator ];
    #settings = { ignorecase = true; };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/State/Projects/Code',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
      '';
     };
}
