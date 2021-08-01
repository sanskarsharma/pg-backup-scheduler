FROM alpine:3.14
LABEL maintainer="Sanskar Sharma <sanskar2996@gmail.com>"

RUN apk update
RUN apk add postgresql-client 

ADD install.sh install.sh
RUN sh install.sh && rm install.sh

ADD run.sh run.sh
ADD backup.sh backup.sh

CMD ["sh", "run.sh"]