http://172.17.0.1:8080

docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v /tmpdata:/data eclipse/che start