include:
  - autoenv
  - epic.lib

.env:
  file:
    - managed
    - name: /home/{{ pillar['home']['user'] }}/epiclib/.env
    - source: salt://autoenv/.env
    - template: jinja
    - user: {{ pillar['home']['user'] }}
    - group: {{ pillar['home']['group'] }}
    - require:
      - cmd: autoenv
      - sls: epic.lib
