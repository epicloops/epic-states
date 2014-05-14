include:
  - epic.lib
  - libmp3splt

/home/{{ pillar['home']['user'] }}/epicsampler:
  file:
    - recurse
    - source: salt://epicsampler
    - include_empty: True
    - user: {{ pillar['home']['user'] }}
    - group: {{ pillar['home']['group'] }}

epicsampler-install:
  cmd:
    - run
    - name: pip install -r ./epicsampler/requirements.txt ./epicsampler
    - cwd: /home/{{ pillar['home']['user'] }}
#    - user: {{ pillar['home']['user'] }}
#    - group: {{ pillar['home']['group'] }}
    - require:
      - sls: epic.lib
      - file: /home/{{ pillar['home']['user'] }}/epicsampler
      - pkg: libmp3splt

# epicsampler-run:
#   cmd:
#     - run
#     - name: . venv/bin/activate && epicsampler
#     - cwd: /home/{{ pillar['home']['user'] }}
#     - user: {{ pillar['home']['user'] }}
#     - group: {{ pillar['home']['group'] }}
#     - require:
#       - cmd: epicsampler-install
