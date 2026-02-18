FROM octree/voca-decidim:0.29-latest
ENV PM2_RUN="decidim,daily,monthly,external_good_job" \
  ROOT="/home/decidim" \
  NODE_ENV=development \
  RAILS_ENV=production

WORKDIR $ROOT
# Configure bundle
RUN bundle config set no_cache true \
  && bundle config set deployment false \
  && bundle config set frozen false \
  && rm -rf vendor voca/Gemfile.lock db/migrate/* 

COPY ./contrib/01_mautic_entrypoint /docker-entrypoint.d/01_mautic_entrypoint
COPY ./contrib/99_recompile /docker-entrypoint.d/99_recompile
COPY . $ROOT

RUN bundle install 
CMD ["pm2-runtime", "start", "config/ecosystem.config.js", "--only", "$PM2_RUN"]
