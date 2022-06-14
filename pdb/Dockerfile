FROM postgres:14.3

ENV POSTGRES_PASSWORD randompassword

USER root
RUN groupadd -g 2000 puser \
    && useradd -u 1001 -g 2000 puser

RUN chown -R 1001:2000 /var/lib/postgresql \
    && chown -R 1001:2000 /var/run/postgresql
