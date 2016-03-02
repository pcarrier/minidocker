RUN apk --no-cache add dropbear && mkdir -p /etc/dropbear
ADD boot.sh /

EXPOSE 2222
CMD /boot.sh dropbear -mswFREp 2222
