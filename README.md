# Mautic community portal
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->
Mautic's community portal is the place where we organize everything within the project that relates to governance and community.

Whether you want to participate in a vote for a new member for the Mautic council,  get involved in a debate about a feature,  find out where your local meetup groups are,  or just learn a bit more about how decisions are made in this open source project,  this is the place for you!

Log in at [community.mautic.org](https://community.mautic.org) with your Mautic community credentials from the forums/website if you're already registered, or create a new account.

##  Contributing to the portal

The community portal runs on the open source software [Decidim](https://decidim.org).

Code changes are accepted via pull requests.  If you find a bug please report it via issues.

If you would like to help with managing the portal itself, claiming membership or any other problems, please reach out via #community on [Slack](https://mautic.org/slack).


# Install the community portal locally

## With a production-like setup
To run almost the same production infrastructure locally:

Start the docker-compose:
```
docker-compose up
```

In a new terminal, you can run a database seed.
```
docker-compose run --rm decidim bundle exec rails db:seed
```

Access: 

- localhost:8080 for the decidim
- localhost:1080 for the mailcatcher

## With a development setup
> Warning, there are known issues running this development docker
> on M1 Apple processor. You have been warned.


Start a decidim instance with no command
```
docker-compose -f docker-compose.dev.yml up -d
```

Run webpacker
```
docker-compose -f docker-compose.dev.yml run --rm decidim bin/webpack-dev-server
```

Run rails server
```
docker-compose -f docker-compose.dev.yml run --rm decidim bundle exec rails s -b 0.0.0.0
```

Run migrations
```
docker-compose -f docker-compose.dev.yml run --rm decidim bundle exec rails db:migrate
```

Run a database seed
```
docker-compose -f docker-compose.dev.yml run --rm decidim bundle exec rails db:seed
```

Access: 

- localhost:3000 for the rails server
- localhost:3000/letter_opener for the mail catcher
- credentials are the default ones (see decidim documentation)

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/imaabasiee"><img src="https://avatars.githubusercontent.com/u/105015897?v=4?s=100" width="100px;" alt="Ima-Abasi E. Effiong"/><br /><sub><b>Ima-Abasi E. Effiong</b></sub></a><br /><a href="#userTesting-imaabasiee" title="User Testing">📓</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!