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

  #powerline-go.enable = true;

  #file.".oh-my-zsh/themes/minimal.zsh-theme".source = "./config/minimal/minimal.zsh";

  zsh.dirHashes = {
    Code = "$HOME/Code";
    sites = "$HOME/Code/sites";
    whrc-portal = "$HOME/Code/sites/whrc-portal";
    "prdeploy.com" = "$HOME/Code/sites/prdeploy";
    "dflydev.com" = "$HOME/Code/sites/dflydev";
    "beausimensen.com" = "$HOME/Code/sites/beausimensen";
  };

  zsh.oh-my-zsh = {
    enable = true;
    theme = "minimal";
    custom = "$HOME/.oh-my-zsh";
  };


  zsh.plugins = [
#    {
#        name = "powerlevel10k";
#        src = pkgs.zsh-powerlevel10k;
#        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
#    }
#    {
#        name = "powerlevel10k-config";
#        src = lib.cleanSource ./config;
#        file = "p10k.zsh";
#    }
  ];

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

    export ALTERNATE_EDITOR=""
    export EDITOR="vim"
    #export VISUAL="vim"

    if [[ -f "${pkgs.zsh-git-prompt}/share/zsh-git-prompt/zshrc.sh" ]]; then
      . "${pkgs.zsh-git-prompt}/share/zsh-git-prompt/zshrc.sh"
    fi

    export MNML_PROMPT=(mnml_status 'mnml_cwd 6 0' git_super_status mnml_keymap)
    export MNML_RPROMPT=()
    #export MNML_MAGICENTER=(mnml_git)
    export MNML_MAGICENTER=()
    '';

  zsh.initExtra = ''

    export ZSH_THEME_GIT_PROMPT_PREFIX=""
    export ZSH_THEME_GIT_PROMPT_SUFFIX=""
    export ZSH_THEME_GIT_PROMPT_SEPARATOR=" "

    #ZSH_THEME_GIT_PROMPT_PREFIX="("
    #ZSH_THEME_GIT_PROMPT_SUFFIX=")"
    #ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
    ZSH_THEME_GIT_PROMPT_BRANCH="\ue0a0%{$fg_bold[magenta]%}"
    ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}%{●%G%}"
    ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
    ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}%{✚%G%}"
    ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
    ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}%{…%G%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"

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
      color.status.untracked = "white normal";
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
