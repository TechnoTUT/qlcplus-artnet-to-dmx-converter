FROM debian:trixie

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y qlcplus xvfb \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* 

COPY fixtures/* /root/.config/qlcplus/fixtures/

ENTRYPOINT [ "/usr/bin/xvfb-run", "qlcplus" ]

CMD ["--debug", "0", "--nowm", "--nogui", "--web", "--kiosk"]