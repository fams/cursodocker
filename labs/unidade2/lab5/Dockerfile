FROM golang:1.22 AS build
LABEL mantainer=fams@linuxplace.com.br
WORKDIR /usr/src/app
COPY go.mod *go ./
RUN  go mod tidy && CGO_ENABLED=0 GOOS=linux go build -o waste-resources

FROM scratch
COPY --from=build /usr/src/app/waste-resources /app/waste-resources
ENV PATH=$PATH:/app
WORKDIR /app
ENTRYPOINT [ "/app/waste-resources" ]
