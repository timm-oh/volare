ARG DEBIAN_VERSION=bookworm-20241016-slim
ARG BUILDER_IMAGE="hexpm/elixir:1.17.3-erlang-27.1.2-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM $BUILDER_IMAGE as builder

# Build Args
ARG PHOENIX_VERSION=1.7.10
ARG MIX_ENV=prod
ENV MIX_ENV $MIX_ENV
ARG DEBIAN_FRONTEND="noninteractive"
# ARG NODEJS_VERSION=16.x

# Apt
RUN apt-get update -qq \
    && apt-get -yq dist-upgrade \
    && apt-get install -yq --no-install-recommends \
       apt-utils \
       build-essential \
       git \
       postgresql-client-15 \
       inotify-tools \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

# Nodejs
# RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION} | bash
# RUN apt-get install -y nodejs

RUN mix local.hex --force && \
    mix archive.install --force hex phx_new $PHOENIX_VERSION && \
    mix local.rebar --force

# App Directory
WORKDIR /app

COPY mix.* ./
RUN mix deps.get --only $MIX_ENV

RUN mkdir config
COPY config/config.exs config/$MIX_ENV.exs config/

RUN mix deps.compile

COPY . ./

RUN if [ "${MIX_ENV}" = "prod" ]; then \
  mix compile && \
  MIX_ENV=prod mix assets.deploy && \
  mix release ; fi

COPY entrypoint.sh /usr/bin/
ENTRYPOINT ["entrypoint.sh"]

CMD mix phx.server

FROM $RUNNER_IMAGE as app
ARG DEBIAN_FRONTEND="noninteractive"
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    MIX_ENV=prod

RUN apt-get update -qq  \
    && apt-get install -yq --no-install-recommends \
    libstdc++6 openssl libncurses5 locales \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/volare ./
COPY --from=builder /app/rel ./rel

CMD /app/bin/server
