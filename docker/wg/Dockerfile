FROM alpine:latest

RUN apk add --no-cache wireguard-tools iptables

CMD ["sh", "-c", "wg-quick up wg0 && tail -f /dev/null"]