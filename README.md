# file2echo
A simple bash script to get an echo command from a text file, in order to recreate it from the command.  
Doesn't work on binary files.

## Download
```bash
wget https://raw.githubusercontent.com/Sad-theFaceless/file2echo/main/file2echo.sh && chmod +x file2echo.sh
```

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
