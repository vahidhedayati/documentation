```bash
$ foo=bar-baz-frob
$ echo ${foo%-*}    # Remove shortest match from the end
bar-baz
$ echo ${foo%%-*}   # Remove longest match from the end
bar
$ echo ${foo#*-}    # Remove shortest match at the beginning
baz-frob
$ echo ${foo##*-}   # Remove longest match at the beginning
frob




echo {server,web}{01..10}{a..z}

for s in {server,web}{01..10}{a..z}; do
    echo Current Server: $s
done
```
