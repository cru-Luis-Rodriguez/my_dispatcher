Custom AEM Adobe cloud dispatcher based on AEM SDK 2.0.90
Build to overcome issue with M1 chipset. 

Follow Adobe Cloud local development environment instructions 
https://experienceleague.adobe.com/docs/experience-manager-learn/cloud-service/local-development-environment-set-up/dispatcher-tools.html

Modify the docker_run.sh by adding the following 2 line before the `else` on line 181.

```

elif [ "${localport}" = "bash" ]; then
cmd="docker run -it --rm --platform linux/amd64 ${volumes} ${envvars} ${imageurl} /bin/bash"
elif [ "${localport}" = "m1" ]; then
cmd="docker run --rm --platform linux/amd64 -p 8081:80 ${volumes} ${envvars} mysite/dispatcher"

```

after adding the above lines entry should look like so: 

```
if [ "${localport}" = "test" ]; then
    cmd="docker run --rm --platform linux/amd64 ${volumes} ${envvars} ${imageurl} /usr/sbin/httpd-test"
elif [ "${localport}" = "bash" ]; then
      cmd="docker run -it --rm --platform linux/amd64 ${volumes} ${envvars} ${imageurl} /bin/bash"
elif [ "${localport}" = "m1" ]; then
      cmd="docker run --rm --platform linux/amd64 -p 8081:80 ${volumes} ${envvars} mysite/dispatcher"
else
    cmd="docker run --rm --platform linux/amd64 -p ${localport}:80 ${volumes} ${envvars} ${imageurl}"
fi
eval "$cmd"
```

On the Dispatcher src update the following file, but do not commit the change. 
`dispatcher_vhost.conf`

Line `152 Require expr "%{HTTP_HOST} == '${POD_NAME}'"`

Remove the quotes.
 `Require expr %{HTTP_HOST} == '${POD_NAME}'`

Otherwise,when launching the dispatcher will throw the following error message. 
```

AH00526: Syntax error on line 152 of /etc/httpd/conf.d/dispatcher_vhost.conf:
Cannot parse expression in require line: syntax error, unexpected $end

```
Reference:
https://blog.bigsmoke.us/2016/07/08/using-require-expr-in-apache-cannot-parse-expression-in-require-line-syntax-error-unexpected-end

To build the custom dispatcher image run: 
`./build.sh`

To execute and test your dispatcher. See the following example commands.

```
DISP_LOG_LEVEL=Debug REWRITE_LOG_LEVEL=Debug docker_run.sh ./src/ host.docker.internal:4503 bash
DISP_LOG_LEVEL=Debug REWRITE_LOG_LEVEL=Debug docker_run.sh ./src/ host.docker.internal:4503 m1
 
```

Run modes

`bash` -- runs the image and connects to the container terminal with bash for troubleshooting
`m1`   -- runs the custom m1 compatible image so that you can test your dispatcher configuration. 




Todo: 
Update image to latest SDK

