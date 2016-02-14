ADD setup.sh /
RUN /setup.sh

EXPOSE 5601
ENTRYPOINT ["su", "-s", "/bin/sh", "kibana", "/kibana/bin/kibana", "--"]
