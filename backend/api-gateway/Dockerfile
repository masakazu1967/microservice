FROM node:20-bookworm AS builder

COPY ./ /usr/src/api-gateway
WORKDIR /usr/src/api-gateway

RUN npm install -g @nestjs/cli
RUN yarn install
RUN yarn build

FROM node:20-bookworm
LABEL org.opencontainers.image.source=https://github.com/masakazu1967/microservice
LABEL org.opencontainers.image.description="マイクロサービスアーキテクチャのNestJSでの実証実験用API Gateway"

COPY --from=builder /usr/src/api-gateway/dist/ /usr/api-gateway/dist
COPY --from=builder /usr/src/api-gateway/node_modules/ /usr/api-gateway/node_modules

WORKDIR /usr/api-gateway
CMD [ "node", "dist/main.js" ]
