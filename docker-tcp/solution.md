# Solutions
There may be other valid ways of doing this but these are the methods that worked for me.

Docker commands can be run against the VM like below:
`docker -H tcp://< IP >:2375 info`

This will allow you to run a interactive container with the root user and mount the hosts file system:
`docker -H tcp://< IP >:2375 run -it -v /:/data ubuntu bash`
