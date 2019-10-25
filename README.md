# trim
A super simple unix utility for removing file extensions and path names from the shell

## Installation
You will need [ghc](https://www.haskell.org) installed!
Then you can run:
```bash
make
sudo make install
```
Simple as that!

## Usage
Input is piped via '|' or '<<<'. Patterns are in the form '{...}' where the '...' is replaced with the following in any
combination:
  1. '.' - removes file extention
  2. '/' - removes path

## Example usage
```bash
$ echo "/etc/hello.world" | trim {/}
hello.world
$ trim {./} <<< "foo/bar/hello.world"
hello
$ # a more useful example that converts all .png files to .jpgs
$ ls *.tex | xargs -i sh -c 'convert {} $(trim {.} <<< {}).jpg'
```
