FROM ubuntu:22.04 as build
LABEL mantainer=fams@linuxplace.com.br
RUN apt update -y && apt install --no-install-recommends -y golang-go
WORKDIR  /src
COPY src/ /src
RUN go mod tidy && go build -o httpserver main.go && cp httpserver /usr/local/sbin
FROM scratch
COPY --from=build /usr/local/bin/httpserver /usr/local/bin/httpserver
ENV PATH=$PATH:/usr/local/bin
COPY ./www/ /var/www/html
WORKDIR  /var/www/html
EXPOSE 8000
ENTRYPOINT [ "httpserver" ]
