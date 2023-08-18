FROM ubuntu:jammy

RUN apt update && \
  apt install -y bash sudo fprintd procps libnotify-bin

WORKDIR /app

COPY system-daemon .
COPY user-daemon .
COPY start.sh .
COPY pkexec.sh .

RUN mv /app/pkexec.sh /bin/pkexec

CMD [ "/bin/bash", "-c", "/app/start.sh" ]