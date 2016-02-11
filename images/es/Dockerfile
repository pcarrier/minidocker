ADD setup.sh /
RUN /setup.sh

EXPOSE 9200 9300
ENTRYPOINT ["su", "-s", "/bin/sh", "es", "/es/bin/elasticsearch"]
