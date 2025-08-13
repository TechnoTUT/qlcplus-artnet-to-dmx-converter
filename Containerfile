FROM debian:trixie

RUN apt-get update \
 && apt-get install -y qlcplus xvfb \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /root/.config/qlcplus/fixtures/

COPY fixtures/* /root/.config/qlcplus/fixtures/

ENTRYPOINT [ "/usr/bin/xvfb-run", "--", "qlcplus" ]

CMD ["--debug", "0", "--nowm", "--nogui", "--web", "--kiosk"]