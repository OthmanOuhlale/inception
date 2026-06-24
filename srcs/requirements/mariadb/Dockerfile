FROM Debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["/setup.sh"]