# Dockerfile
FROM rust:1-stretch as builder
# Choose a workdir
WORKDIR /usr/src/app
# Create blank project
RUN USER=root cargo init
# Copy Cargo.toml to get dependencies
COPY Cargo.toml .
# This is a dummy build to get the dependencies cached
RUN cargo build --release
# Copy sources
COPY src src
COPY contracts contracts
RUN touch src/main.rs && cargo build --release

FROM debian:stretch-slim
RUN apt-get update && apt-get --yes install openssl
COPY --from=builder /usr/src/app/target/release/etherbalance /bin/
CMD etherbalance
