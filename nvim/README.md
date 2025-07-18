# cheatsheet

## keymaps

| mode | keys                                               | what?!                                                       |
| ---- | -------------------------------------------------- | ------------------------------------------------------------ |
| n    | <kbd>viwp</kbd>                                    | replace word with pasteboard (register 0)                    |
| n    | <kbd>vep</kbd>                                     | replace word with pasteboard, from curr to end (register 0)  |
| n    | <kbd>cs'"</kbd>                                    | change surrounding ' to "                                    |
| n    | <kbd>cst</kbd>                                     | change surrounding tag (rename both open/close tags)         |
| n    | <kbd>ysiWt</kbd> <kbd>span class="highlight"</kbd> | surround Word with new tag (e.g. with attributes)            |
| i    | <kbd>\<C-r\>0</kbd>                                | paste from registry 0                                        |
| v    | <kbd>St</kbd> <kbd>div class="p-10"</kbd>          | Surround lines with new tag (e.g. with attributes)           |
| n    | <kbd>q:</kbd>                                      | open command window (search history of commands)             |
| n    | <kbd>:r FILE</kbd>                                 | retrieve the contents of FILE at cursor                      |
| n    | <kbd>:r !ls</kbd>                                  | retrieve the contents of the <kbd>ls</kbd> command at cursor |
| v    | <kbd>P</kbd> | paste over selection (<kbd>P</kbd> does not write the deleted text to register == nice repeated overwrites, <kbd>p</kbd> however does write to registers) |
| n    | <kbd>m`</kbd> | add current cursor position (line:col) to the temporary mark ` |
| n    | <kbd>``</kbd> | go to the temporary mark ` |
| i | <kbd>\<C-r\>\<C-r\>h</kbd> | paste contents of recorded macro in register h |

## commands

| command | what?!                                    |
| ------- | ----------------------------------------- |
| :e      | (edit) reload buffer from disk            |
| :noa w  | noautocommand w (save without formatting) |

## lua

- `vim.api.nvim_feedkeys("some_string_of_keys", 'n', true)` lets you emulate keyboard input.

## behaviours

- for `telescope-file-browser`, to create a directory instead of a file, include a trailing slash: `somefile/`
