# Volare

Welcome to volare 👋

The goal of this project is to allow anyone to do open banking payments.

## Prerequisites

* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* [Cloudflare tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/).
Needs to be a static domain because banks will make requests for certificate data per request (e.g. revolut).
You're going to have a hard time if its not a static domain as this will require you to update it with the various providers manually.
* [direnv](https://direnv.net/) - This isn't a hard requirement, but it does make working with env vars a little more sane :)

## Getting started

Start up your cloudflare tunnel: `cloudflared tunnel run {name}`

Once you have setup your cloudflare tunnel to point to port 4000 on your machine, create a `compose.override.yml` file with the following content:

```yaml
services:
  web:
    environment:
      PHX_HOST: {sub.domain.tld}
```

We're heavily using docker for development, testing and deployments.

To get started, run `docker compose up --build`.
Once it's built, navigate to the domain that you setup for your cloudflare tunnel.

You should see our landing page.
Profit 💰

## Deployment

Currently we're auto deploying every commit that is merged into master.
We're using [fly.io](https://fly.io/) for hosting.
