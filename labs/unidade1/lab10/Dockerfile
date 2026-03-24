FROM ubuntu:22.04 AS build
LABEL mantainer=fams@linuxplace.com.br
RUN apt update -y && apt install --no-install-recommends -y golang-go
WORKDIR /src
COPY src/ /src
RUN go mod tidy && CGO_ENABLED=0 GOOS=linux go build -o httpserver main.go

FROM scratch
COPY --from=build /src/httpserver /usr/local/bin/httpserver
ENV PATH=$PATH:/usr/local/bin
COPY ./www/ /var/www/html
WORKDIR  /var/www/html
EXPOSE 8000
ENTRYPOINT [ "/usr/local/bin/httpserver" ]
