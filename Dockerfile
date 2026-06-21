FROM node:8.11.4-alpine

WORKDIR /app

RUN npm config set registry https://registry.npmmirror.com/ \
&& npm i -g pm2@3.5.1 --no-optional --unsafe-perm

COPY package.json ./
RUN npm install --production

COPY . .

# Create process.json for pm2 to run local ./bin/www
RUN echo '{ "apps" : [ { "name": "code-push-server", "max_memory_restart": "500M", "script": "./bin/www", "instances": "max", "exec_mode": "cluster" } ] }' > /process.json

EXPOSE 3000

ENV PM2_HOME=/app/.pm2
RUN mkdir -p /app/.pm2

CMD ["pm2-docker", "start", "/process.json"]
