import {$} from 'bun'

export const set_by_app = (app: string, options: string) => {
	return $`yabai -m query --windows \
    | jq ".[] | select(.app == \"${app}\").id" \
    | xargs -L1 sh -c 'yabai -m window $0 ${{raw: options}}'`
}

export const set_by_win = (win_id: string, options: string) => {
	return $`yabai -m window ${win_id} ${{raw: options}}`
}

export const lock_all_set = async (options?: string) => {
	const app = '.*'

	const signal_list = await $`yabai -m signal --list`.json()
	const signal_locked = signal_list.find((x) => x.label === 'lock_.*')

	// TODO: separate from lock update where options are not needed
	if (!options && !signal_locked) {
		return
	}

	const locked_list = signal_list.filter((x) => x.label.startsWith('lock_') && x.label !== 'lock_.*')

	const ignored = locked_list.map((x) => x.app).join('|')
	const action = options ? `yabai -m window \$YABAI_WINDOW_ID ${options}` : signal_locked.action

	return $`yabai -m signal --add event=window_created label="lock_${app}" app="${app}" app!="^${ignored}$" action="${{raw: action}}"`
}

export const lock_by_app = async (app: string, options?: string) => {
	await $`yabai -m signal --add event=window_created label="lock_${app}" app="${app}" action="yabai -m window \$YABAI_WINDOW_ID ${{raw: options}}"`
	await lock_all_set()
}
export const unlock_by_app = async (app: string) => {
	await $`yabai -m signal --remove "lock_${app}"`
	await lock_all_set()
}

// TODO: calculate based on the screen size
// The grid format is <rows>:<cols>:<start-x>:<start-y>:<width>:<height>, where rows and cols are how many rows and
// columns there are in total, start-x and start-y are the start indices for the row and column and width and
// height are how many rows and columns the window spans.
export const commands = {
	main: () => `--grid 1:12:2:0:8:1`,
	left: () => `--grid 1:12:0:0:2:1`,
	right: () => `--grid 1:12:11:0:12:1`,
	centre: () => `--grid 12:12:2:1:8:10`,
	small: () => `--grid 24:24:6:3:12:18`,
	current: (win) => {
		return `--resize abs:${win.frame.w}:${win.frame.h} --move abs:${win.frame.x}:${win.frame.y}`
	},
}

export const run = async (type: 'app' | 'win' | 'lock' | 'unlock' | 'unlock_all', command: keyof typeof commands) => {
	const win = await $`yabai -m query --windows --window`.json()

	if (type === 'unlock') {
		return unlock_by_app(win.app)
	}

	if (type === 'unlock_all') {
		return unlock_by_app('.*')
	}

	const opts = commands[command]?.(win)

	if (!opts) {
		return
	}

	if (type === 'app') {
		return set_by_app(win.app, opts)
	}

	if (type === 'win') {
		return set_by_win(win.id, opts)
	}

	if (type === 'lock') {
		return lock_by_app(win.app, opts)
	}

	if (type === 'lock_all') {
		return lock_all_set(opts)
	}
}
