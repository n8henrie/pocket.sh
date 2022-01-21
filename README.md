## pocket.sh

Bash script to read urls from stdin and batch add them to pocket. Working on
MacOS 12.1 with bash 5.

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
