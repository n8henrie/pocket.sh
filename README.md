## pocket.sh

Bash script to read urls from stdin and batch add them to pocket. Working on
MacOS 12.1.

Dependencies:
- bash 5 (e.g. via homebrew)
- Create an API consumer_key and set it in `config.env` (copy from
  `config-sample.env`)
    - Needs at least `modify` scope
    - https://getpocket.com/developer/apps/

Usage example:

```console
$ curl --silent https://ianthehenry.com/posts/how-to-learn-nix/ |
    xmllint --html --xpath '//a[contains(@href, "how-to-learn-nix")]/@href' - |
    awk -F'"' '{ print "https://ianthehenry.com" $(NF-1) }' |
    ./pocket.sh
```

## Acknowledgments:

- https://getpocket.com/
- https://www.jamesfmackenzie.com/getting-started-with-the-pocket-developer-api/
