# see https://github.com/kovidgoyal/kitty/commit/787100a4dcd3d9c338bfc15511e4a4824a865e6a

def main(args):
  pass

def handle_result(args, answer, target_window_id, boss):
  tab = boss.active_tab

  if tab is not None:
     if tab.current_layout.name == 'stack':
        tab.last_used_layout()
     else:
        tab.goto_layout('stack')

handle_result.no_ui = True
