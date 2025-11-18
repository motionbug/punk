FROM node:lts-alpine AS builder
WORKDIR /build
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build

FROM node:lts-alpine
LABEL description="Punked Tart - Pure Packer file management"
LABEL version="1.0"
WORKDIR /srv
COPY --from=builder /build/dist ./dist
RUN yarn global add --silent serve
EXPOSE 8080
CMD [ "serve", "-l", "8080", "-s", "dist" ]
