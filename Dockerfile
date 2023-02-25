FROM node:16.19.1-buster
#FROM node:16.19.1-alpine3.16
# FROM node:16.19.1-slim
# FROM ubuntu:20.04

ARG CONTRACTS_REPO=surfingnerd
ARG CONTRACTS_COMMIT_HASH=7d53424907c116ba59a47c3270a431e0b53386d2
ARG NODE_REPO=surfingnerd
ARG NODE_COMMIT_HASH=d83dbbe3a310a54046269aa95963f0c7adf7ddd9
ARG TESTING_REPO=surfingnerd
ARG TESTING_COMMIT_HASH=31aa74bc182a07df1a4a4ee3972325aa2f85f7ff

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install apt-utils git-core curl cmake net-tools zsh -y
# RUN apk update
# RUN apk add git curl cmake net-tools zsh

# rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# NodeJS
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# RUN export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
# RUN nvm install 16.19.1 && nvm alias default 16.19.1

# contracts
RUN cd /root && git clone https://github.com/$CONTRACTS_REPO/hbbft-posdao-contracts.git && cd hbbft-posdao-contracts && git checkout $CONTRACTS_COMMIT_HASH
RUN cd /root/hbbft-posdao-contracts && npm ci && npm run compile && mkdir -p build/contracts && find artifacts/**/*.sol/*json -type f -exec cp '{}' build/contracts ';' && cd ..

# diamond node
RUN cd /root && git clone https://github.com/$NODE_REPO/diamond-node.git && cd diamond-node && git checkout $NODE_COMMIT_HASH
# we don't need to build the node, becaus it is build by the testing repo
# RUN cd /root/diamond-node && . "$HOME/.cargo/env" &&  rustup default 1.64 && RUSTFLAGS='-C target-cpu=native' && cargo build --profile perf && cd ..

# honey badger testing
RUN cd /root && git clone https://github.com/$TESTING_REPO/honey-badger-testing.git && cd honey-badger-testing && git checkout $TESTING_COMMIT_HASH
WORKDIR /root/hbbft-posdao-contracts
RUN mkdir -p build/contracts && find artifacts/contracts -name "*.json" -exec cp '{}' /root/hbbft-posdao-contracts/build/contracts/ ';'
RUN rm /root/hbbft-posdao-contracts/build/contracts/*.dbg.json
WORKDIR /root/honey-badger-testing
RUN . "$HOME/.cargo/env" && npm ci
RUN . "$HOME/.cargo/env" && npm run build-open-ethereum
RUN . "$HOME/.cargo/env" && npm run testnet-fresh
# honey badger testing

WORKDIR /root/honey-badger-testing

CMD npm run testnet-start-current