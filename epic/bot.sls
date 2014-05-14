include:
  - langs.python2.pip
  - epic.lib
  - libxml2-dev
  - libxslt1-dev
  - openssl
  - scrapyd

/tmp/epicbot:
  file:
    - recurse
    - source: salt://epicbot
    - include_empty: True

epicbot-requirements:
  cmd:
    - run
    - name: pip install -r ./requirements.txt
    - cwd: /tmp/epicbot
    - require:
      - sls: langs.python2.pip
      - sls: epic.lib
      - file: /tmp/epicbot
      - pkg: libxml2-dev
      - pkg: libxslt1-dev
      - pkg: libssl1.0.0

epicbot-egg:
  cmd:
    - run
    - name: python setup.py bdist_egg
    - cwd: /tmp/epicbot
    - require:
      - file: /tmp/epicbot

epicbot-install:
  cmd:
    - run
    - name: curl http://localhost:6800/addversion.json -F project=epicbot -F version=0.1.0 -F egg=@dist/epicbot-0.1.0-py2.7.egg
    - cwd: /tmp/epicbot
    - require:
      - cmd: epicbot-requirements
      - cmd: epicbot-egg
      - pkg: scrapyd
