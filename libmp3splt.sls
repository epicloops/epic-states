libmp3splt:
  pkgrepo:
    - managed
    - name: deb http://ppa.launchpad.net/m-ioalex/mp3splt/ubuntu precise main
  pkg:
    - installed
    - pkgs:
      - libmp3splt0-mp3
      - libmp3splt0-ogg
      - libmp3splt0-flac
      - mp3splt
    - skip_verify: True
    - require:
      - pkgrepo: libmp3splt
