FROM debian:trixie

RUN apt-get update \
 && apt-get install -y qlcplus\
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /root/.config/qlcplus/fixtures/

COPY fixtures/* /root/.config/qlcplus/fixtures/

ENV QT_QPA_PLATFORM=offscreen

ENTRYPOINT ["qlcplus"]

CMD ["--debug", "0", "--nowm", "--nogui", "--web", "--kiosk"]