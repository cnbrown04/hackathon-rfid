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

const WS_URL = "ws://localhost:3001";

export type WelcomeSocketHandlers = {
	onWelcome: (user: WelcomeUser) => void;
	onTourRoster?: (payload: TourRosterPayload) => void;
};

export function connectWelcomeSocket(handlers: WelcomeSocketHandlers) {
	let ws: WebSocket;

	function connect() {
		ws = new WebSocket(WS_URL);

		ws.onmessage = (event) => {
			const msg = JSON.parse(event.data);
			if (msg.type === "welcome") {
				handlers.onWelcome(msg.data as WelcomeUser);
			} else if (msg.type === "tour_roster" && handlers.onTourRoster) {
				handlers.onTourRoster(msg.data as TourRosterPayload);
			}
		};

		ws.onclose = () => {
			setTimeout(connect, 2000);
		};
	}

	connect();

	return () => ws.close();
}
