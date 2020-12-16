FROM debian:stretch as build

RUN apt update && apt install -y curl build-essential \
  libasound2-dev pkg-config

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup.sh
RUN sh /tmp/rustup.sh -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo install librespot

FROM debian:stretch

RUN apt update && apt install -y libasound2-dev && apt clean

COPY --from=build /root/.cargo/bin/librespot /usr/bin/librespot

CMD ["librespot", "--disable-audio-cache", "-n", "raspoty", "-b", "320"]
