FROM node:20-bookworm AS builder

COPY ./ /usr/src/user-service
WORKDIR /usr/src/user-service

RUN npm install -g @nestjs/cli
RUN yarn install
RUN yarn build

FROM node:20-bookworm
LABEL org.opencontainers.image.source=https://github.com/masakazu1967/microservice
LABEL org.opencontainers.image.description="マイクロサービスアーキテクチャのNestJSでの実証実験用ユーザーサービス"

COPY --from=builder /usr/src/user-service/dist/ /usr/user-service/dist
COPY --from=builder /usr/src/user-service/node_modules/ /usr/user-service/node_modules

WORKDIR /usr/user-service
CMD [ "node", "dist/main.js" ]
