# cheatsheet

## keymaps

| mode | keys | what?! |
| --- | --- | ------ |
| n | <kbd>viwp</kbd> | replace word with pasteboard (register 0) |
| n | <kbd>vep</kbd> | replace word with pasteboard, from curr to end (register 0) |
| n | <kbd>cs'"</kbd> | change surrounding ' to " |
| n | <kbd>cst</kbd> | change surrounding tag (rename both open/close tags) |
| n | <kbd>ysiWt</kbd> <kbd>span class="highlight"</kbd> | surround Word with new tag (e.g. with attributes) |
| i | <kbd>\<C-r\>0</kbd> | paste from registry 0 |
| v | <kbd>St</kbd> <kbd>div class="p-10"</kbd> | Surround lines with new tag (e.g. with attributes) |


## commands

| command | what?! |
| --- | --- |
| :e | (edit) reload buffer from disk |
| :noa w | noautocommand w (save without formatting) |

## behaviours

- for `telescope-file-browser`, to create a directory instead of a file, include a trailing slash: `somefile/`
