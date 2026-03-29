import { viteWsUrl } from "./env-urls";

/** Demo EPC used in antenna flow test data */
export const PLACEHOLDER_EPC = "E28069950000500CA794A47F";

export type WelcomeUser = {
	epc: string;
	first_name: string;
	last_name: string;
	email: string | null;
	company: string | null;
	title: string | null;
	photo_url: string | null;
	arrived_at: string;
};

export type TourRosterPayload = {
	tour_id: string;
	company: string;
	/** Company logo image URL (optional). */
	logo?: string | null;
	start_time: string | null;
	/** EPC of the ambassador whose scan loaded this roster (shown as arrived). */
	scanned_epc: string;
	/** When the ambassador scan was processed (ISO). */
	scanned_at?: string;
	people: WelcomeUser[];
};

export type WelcomeSocketHandlers = {
	onWelcome: (user: WelcomeUser) => void;
	onTourRoster?: (payload: TourRosterPayload) => void;
	/** Admin broadcast: reset all welcome UI to the waiting state. */
	onWelcomeClear?: () => void;
};

/** Welcome kiosk UI only reacts to the welcome reader (reader-2), not LiDAR or other readers. */
function isWelcomeReaderMessage(msg: {
	reader_id?: string | null;
	type?: string;
}): boolean {
	if (msg.reader_id == null) {
		return true;
	}
	return msg.reader_id === "reader-2";
}

export function connectWelcomeSocket(handlers: WelcomeSocketHandlers) {
	let ws: WebSocket;

	function connect() {
		ws = new WebSocket(viteWsUrl());

		ws.onmessage = (event) => {
			const msg = JSON.parse(event.data) as {
				type: string;
				reader_id?: string | null;
				data?: unknown;
			};
			if (msg.type === "welcome") {
				if (!isWelcomeReaderMessage(msg)) {
					return;
				}
				handlers.onWelcome(msg.data as WelcomeUser);
			} else if (msg.type === "tour_roster" && handlers.onTourRoster) {
				if (!isWelcomeReaderMessage(msg)) {
					return;
				}
				handlers.onTourRoster(msg.data as TourRosterPayload);
			} else if (msg.type === "welcome_clear" && handlers.onWelcomeClear) {
				handlers.onWelcomeClear();
			}
		};

		ws.onclose = () => {
			setTimeout(connect, 2000);
		};
	}

	connect();

	return () => ws.close();
}
