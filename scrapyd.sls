include:
  - libxml2-dev
  - libxslt1-dev
  - openssl

scrapyd:
  pkgrepo:
    - managed
    - name: deb http://archive.scrapy.org/ubuntu scrapy main
    - keyid: '627220E7'
    - keyserver: hkp://keyserver.ubuntu.com:80
  pkg:
    - installed
    - pkg: scrapy-0.22
    - skip_verify: True
    - require:
      - pkgrepo: scrapyd
      - pkg: libxml2-dev
      - pkg: libxslt1-dev
      - pkg: libssl1.0.0
