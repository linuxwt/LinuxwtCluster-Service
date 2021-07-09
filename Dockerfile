FROM mongo:3.6.4

ADD mongodb-keyfile /data/config/mongodb-keyfile
RUN chown mongodb:mongodb /data/config/mongodb-keyfile && chmod 600 /data/config/mongodb-keyfile
