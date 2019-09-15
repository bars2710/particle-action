# build stage
FROM golang:alpine AS build-env
RUN apk --no-cache add build-base git gcc ca-certificates
COPY go.mod particle.go /src/
RUN cd /src && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o main

# final stage
FROM scratch

LABEL "com.github.actions.name"="Particle"
LABEL "com.github.actions.description"="Invoke a Particle Function"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/mattdsteele/particle-action"
LABEL "homepage"="http://github.com/actions"
LABEL "maintainer"="mattdsteele <orphum@gmail.com>"

COPY --from=build-env /src/main /
COPY --from=build-env /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/main"]
