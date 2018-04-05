#!/usr/bin/python

import subprocess

GOLDEN_RATIO = 1.618

def tmux_cmd(*args):
    if len(args) == 1 and isinstance(args[0], list):
        return subprocess.check_output(['tmux'] + args[0])
    else:
        return subprocess.check_output(['tmux'] + args[0].split())

window = {}
window['width'], window['height'] = [float(val) for val in tmux_cmd(['display-message', '-p', '#{window_width} #{window_height}']).split()]

# panes = {}
# active_pane = None

# panes_list = tmux_cmd(['list-panes', '-F', '#P #{pane_width} #{pane_height} #{pane_active} #{pane_left} #{pane_right}'])
# for pane_line in panes_list.splitlines():
#     id, width, height, is_active, left, right = pane_line.split()
#     pane = {
#         'width': int(width),
#         'height': int(height),
#         'active': is_active == '1',
#         'left': int(left),
#         'right': int(right)
#     }
#     if pane['active']:
#         active_pane = pane
#     panes[int(id)] = pane
enabled = True
try:
    enabled = (tmux_cmd('show-env -g GR').split('=')[1].strip() != '0')
except Exception:
    pass

if enabled:
    tmux_cmd('resize-pane -x {} -y {}'.format(int(window['width'] / GOLDEN_RATIO), int(window['height'] / GOLDEN_RATIO)))
