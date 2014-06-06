**Update:** Updated the syntax file, redownload it if you got it before December 19th 2007.

More news about my adventures with Selenium. It's hot and juicy, so lot's of exciting new things to
do. I made a syntax highlighter for plain text stories in vim. Here's how it looks:

To make it look like this, I adjusted the slate colorscheme and added my own story syntax file.

### Here is what you need to do:

Put the black-slate colorscheme file in /usr/share/vim/vim71/colors directory

Put the story syntax file in /usr/share/vim/vim71/syntax directory

Append these lines to the end of /usr/share/vim/vim71/scripts.vim:

``` vim
if did_filetype()
  finish
endif
if getline(1) =~ "^Story:\s.*"
  setf story
endif
```

Add these lines to your personal vimrc (~/.vimrc) or the systemwide vimrc file (/etc/vim/vimrc):

``` vim
set background=dark
set tabstop=2   "please default all tabs to 2 spaces
set shiftwidth=2
set expandtab
set number
set smartindent
set smarttab
filetype plugin on
filetype indent on
colorscheme black-slate
```

Type your plain text stories, make sure every story file starts with 'Story:' It won't recognize
it's a plain text story right away, so first type 'Story:', save it and reopen it to get nice
colours.

By the way, Arie has made a syntax highlighter for the google javascript syntax highlighter. Keep a
look out on [his blog](http://ariekanarie.nl/) too!
