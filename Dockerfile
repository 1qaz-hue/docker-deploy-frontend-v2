FROM node:22-alpine AS build-stage 
WORKDIR /app 
COPY package*.json ./ 
RUN npm config set registry https://registry.npmmirror.com && npm install
COPY . . 
ARG BUILD_MODE=production 
RUN npm run build -- --mode ${BUILD_MODE} 

FROM nginx:alpine AS production-stage 
COPY nginx-custom.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
