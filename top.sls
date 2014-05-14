qa:
  '*-qa':
    - ssh.client
    - ssh.server
    - vcs.git
    - sh.zsh
    - edit.nano
    - langs.python2
    - langs.python2.pip
    - langs.python2.python-dev
    - libpq-dev
    - epic.lib

  'epic-master-qa':
    - salt.gitfs
    - salt.cloud
    - dotfiles.aws.keys

  'epic-bot\d+-qa':
    - match: pcre
    - libxml2-dev
    - libxslt1-dev
    - openssl
    - scrapyd
    - epic.bot

  'epic-sampler\d+-qa':
    - match: pcre
    - libmp3splt
    - epic.sampler
