## Update pangolin data only. The tool itself stays at the image's pinned
## version (pixi, pangolin=4.2): a self-updating binary inside a pinned image
## breaks reproducibility of surveillance calls. Data designations still
## refresh hourly via deck-chores.
## Full tool update stays available manually:
##   python3 manage.py update_pangolin

set -e
/software/miniconda2/envs/pangolin/bin/pangolin --update-data
