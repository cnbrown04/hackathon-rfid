import { viteWsUrl } from "./env-urls";

/** Row from the `localize` table */
export type LocalizeEvent = {
	event_ts: string;
	antenna_id: number;
	epc: string;
	avg_rssi: number | null;
	read_count: number | null;
};

export function connectLocalizationSocket(
	onEvent: (event: LocalizeEvent) => void,
) {
	let ws: WebSocket;

	function connect() {
		ws = new WebSocket(viteWsUrl());

		ws.onmessage = (event) => {
			const msg = JSON.parse(event.data);
			if (msg.type === "localize") {
				onEvent(msg.data as LocalizeEvent);
			}
		};

		ws.onclose = () => {
			setTimeout(connect, 2000);
		};
	}

	connect();

	return () => ws.close();
}
