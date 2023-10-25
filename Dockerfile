FROM hfroger/decidim:0.27 as build
FROM hfroger/decidim:0.27
ENV PM2_RUN="decidim,sidekiq" ROOT="/home/decidim/app"
RUN apt-get update -yq \
# Install native deps
  && apt-get install -yq restic systemd rsyslog wget zip sharutils libicu-dev libpq-dev nginx \ 
# Clean installation clutters
  && apt-get clean \
  && apt-get autoremove -y  \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log \
  && mkdir -p /etc/jelastic/\
  && mkdir -p $ROOT/tmp \
  && cd $ROOT \
  && npm install -g pm2 \
  && rm -rf /usr/local/bundle/cache  \
# Add a nginx user
  && useradd -u 1002 -g 1001 -r -s /bin/sh nginx \
# Configure bundle
  && bundle config set --local path "vendor" \
  && bundle config set --local with "production" \
  && bundle config set --local no_cache "true" \
  && bundle config set --local deployment "true"

COPY ./00_mautic_entrypoint.sh /usr/local/share/docker-entrypoint.d/00_mautic_entrypoint.sh
COPY --chown=nginx:decidim ./contrib/nginx/nginx.conf /etc/nginx/nginx.conf
USER decidim
COPY --from=build --chown=decidim:decidim $ROOT $ROOT
COPY --chown=decidim:decidim . $ROOT
CMD ["pm2-runtime", "start", "/home/decidim/app/config/ecosystem.config.js", "--only", "$PM2_RUN"]
