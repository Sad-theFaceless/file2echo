# file2echo
A simple bash script to get an echo command from a text file, in order to recreate it from the command.  
Doesn't work on binary files.

## Download
### GNU/Linux
```bash
wget https://raw.githubusercontent.com/Sad-theFaceless/file2echo/main/file2echo.sh && chmod +x file2echo.sh
```
### Windows
- Open the [link to the raw script](https://raw.githubusercontent.com/Sad-theFaceless/file2echo/main/file2echo.sh), right click and **Save as...**
- Install [Git for Windows](https://github.com/git-for-windows/git/releases/latest) (the one ending with **-64-bit.exe**)
  - Make sure the box "**Git Bash Here**" is checked
  - Select "**Use Windows' default console window**" to get a prettier terminal
- Right click on your File Explorer where you saved the script, then click on **Git Bash Here**

## How to use
### Get the echo command
```bash
./file2echo.sh $FILE
```
### Directly recreate a new file from the echo command
```bash
./file2echo.sh $FILE | bash > $NEW_FILE
```

## Example
Taking a `getIP.sh` file with the following content:
```bash
#!/bin/sh

dig +short myip.opendns.com @resolver1.opendns.com A
```
Inside the terminal:
```bash
./file2echo.sh getIP.sh
```
Output:
```bash
echo -ne '#!/bin/sh\n\ndig +short myip.opendns.com @resolver1.opendns.com A\n'
```
