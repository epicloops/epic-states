include:
  - langs.python2.pip
  - langs.python2.python-dev
  - libpq-dev

epiclib-config:
  file:
    - managed
    - name: /etc/epic/config
    - source: salt://epic/config
    - template: jinja
    - makedirs: True

epiclib-src:
  file:
    - recurse
    - name: /tmp/epiclib
    - source: salt://epiclib
    - include_empty: True

epiclib-install:
  cmd:
    - run
    - name: pip install --ignore-installed -r ./epiclib/requirements.txt ./epiclib
    - cwd: /tmp
    - require:
      - sls: langs.python2.pip
      - file: /tmp/epiclib
      - pkg: python-dev
      - pkg: libpq-dev
