FROM node:12-alpine AS builder

WORKDIR /opt/accounts
COPY package.json yarn.lock ./
RUN yarn install

COPY babel.config.js vue.config.js ./
COPY public ./public/
COPY src ./src/
RUN yarn build


FROM nginx:stable-alpine

RUN rm /etc/nginx/conf.d/*
COPY nginx.conf /etc/nginx/conf.d/site.conf

COPY --from=builder /opt/accounts/dist/ /srv/accounts/

ENV IAM_BASE_URL=http://localhost:8080/v1 \
    IAM_LOGIN_URL=/users/\${username}/login \
    IAM_VERIFY_URL=/users/\${username}/login \
    IAM_CREATE_ACCOUNT_URL=/users \
    IAM_GET_USER_DATA_URL=/users/self \
    IAM_UPDATE_USER_DATA_URL=/users/self

ENV PAYMENT_BASE_URL=http://localhost:4242 \
    PAYMENT_CREATE_SESSION_URL=/create-session

ENV STRIPE_PUBLIC_KEY=

ENV SUPPORT_EMAIL=support@netsoc.ie \
    MAIN_WEBSITE_URL=http://localhost:4000/services/ \
    BLURB="We provide free web hosting and file storage on our servers, tech talks and tutorials for all skill levels. Learn how to build your own webpage and host it on our servers! Find out more by clicking on our logo above!"


COPY entrypoint.sh /accounts-entrypoint.sh
ENTRYPOINT ["/accounts-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
