#compdef zk

_zk() {
  _values options \
    lucky config n ni daily standup ls recent journal \
    ls-standup edlast t ideas update rm slides wc bl log \
    sync
}

_zk "$@"
