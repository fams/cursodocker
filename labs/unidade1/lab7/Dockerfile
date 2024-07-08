FROM ubuntu:22.04
LABEL mantainer=fams@linuxplace.com.br
WORKDIR  /var/www/html
EXPOSE 80
RUN apt-get update -y && apt-get install --no-install-recommends python3 -y
COPY ./www/ /var/www/html
ENTRYPOINT [ "python3", "-m", "http.server", "80" ]
