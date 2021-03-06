Vim Tmux Navigator
==================

This plugin is a repackaging of [Mislav Marohnić's][] tmux-navigator
configuration described in [this gist][], and a slight rewrite of
[christoomey's plugin][] that this is a fork of and also incorporates
the zoom idea from [svenfuchs' gist][].

When combined with a set of tmux key bindings and the provided ruby script,
the plugin will allow you to navigate seamlessly between vim and tmux splits
using a consistent set of hotkeys.

**NOTE**: This requires tmux v1.8 or higher.

Difference from christoomey/vim-tmux-navigator and other influences
-------------------------------------------------------------------

This plugin and it's parts are based on the fine work by [mislav], [christoomey], and [svenfuchs].
There were a few things I wanted to change/incorporate. Here's what I changed:

1. This fork adds a zoom feature. When navigating past the last screen in any direction,
   (whether it be a vim window or tmux split), this plugin with toggle the tmux zoom feature.
2. This fork uses an external script instead of large inlined shell script. This makes
   setup a little more complicated, but simplifies the tmux config. It also requires ruby.
3. [svenfuchs' gist][] sends :ex commands to vim. Because of this, moving between vim splits
   doesn't work in insert mode. This fork overrides F1-8 keys, which allows the movements to work
   in any vim mode. If you use vim mappings for F keys, this plugin probably won't work. However,
   you should be able to pick your own "secret" mappings in `tmux-vim-select-pane.rb`.
4. I do not use the *toggle between last active pane* feature, so I have not tried to get it to work.


Usage
-----

This plugin provides the following mappings which allow you to move between
Vim panes and tmux splits seamlessly.

- `<ctrl-h>` => Left
- `<ctrl-j>` => Down
- `<ctrl-k>` => Up
- `<ctrl-l>` => Right

When using any of these keys when moving would move off the screen will

**Note** - you don't need to use your tmux `prefix` key sequence before using
the mappings.


Installation
------------

### Vim

If you don't have a preferred installation method, I recommend using [vim-update-bundles][].
Assuming you have Vundle installed and configured, the following steps will
install the plugin:

Add the following line to your `~/.vimrc` file

``` vim
" Bundle 'amiel/vim-tmux-navigator'
```

### tmux-vim-select-pane.rb

Download [tmux-vim-select-pane.rb][]; make sure it is executable and in your path.

### Tmux

Add the following to your `tmux.conf` file to configure the tmux side of
this customization.

``` tmux
# Smart pane switching with awareness of vim splits
bind -n C-k run-shell 'tmux-vim-select-pane.rb -U'
bind -n C-j run-shell 'tmux-vim-select-pane.rb -D'
bind -n C-h run-shell 'tmux-vim-select-pane.rb -L'
bind -n C-l run-shell 'tmux-vim-select-pane.rb -R'
```



### Restoring Clear Screen (C-l)

The default key bindings include `<Ctrl-l>` which is the readline key binding
for clearing the screen. The following binding can be added to your `~/.tmux.conf` file to provide an alternate mapping to `clear-screen`.

``` tmux
bind C-l send-keys 'C-l'
```

With this enabled you can use `<prefix> C-l` to clear the screen.

Thanks to [Brian Hogan][] for the tip on how to re-map the clear screen binding.

Troubleshooting
---------------

### Vim -> Tmux doesn't work!

This is likely due to conflicting key mappings in your `~/.vimrc`. You can use
the following search pattern to find conflicting mappings `\vn(nore)?map\s+\<c-[hjkl]\>`. Any matching lines should be deleted or altered to avoid conflicting
with the mappings from the plugin.

### Tmux Can't Tell if Vim Is Active

This functionality requires tmux version 1.8 or higher. You can check your
version to confirm with this shell command:

``` bash
tmux -V # should return 'tmux 1.8' or higher
```

[christoomey's plugin]: https://github.com/christoomey/vim-tmux-navigator
[svenfuchs' gist]: https://gist.github.com/svenfuchs/6146321
[tmux-vim-select-pane.rb]: https://github.com/christoomey/vim-tmux-navigator
[Brian Hogan]: https://twitter.com/bphogan
[Mislav Marohnić's]: http://mislav.uniqpath.com/
[vim-update-bundles]: https://github.com/bronson/vim-update-bundles
[this blog post]: http://www.codeography.com/2013/06/19/navigating-vim-and-tmux-splits
[this gist]: https://gist.github.com/mislav/5189704
