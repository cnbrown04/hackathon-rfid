import { viteWsUrl } from "./env-urls";

export type LocalizationEvent = {
	id: number;
	event_id: string;
	event_ts: string;
	site_id: string | null;
	reader_id: string | null;
	epc: string;
	x_ft: number | null;
	y_ft: number | null;
	confidence: number | null;
	rssi_1: number | null;
	rssi_2: number | null;
	rssi_3: number | null;
	r1_ft: number | null;
	r2_ft: number | null;
	r3_ft: number | null;
	created_at: string;
	quality?: {
		rmse_ft?: number;
		freshness_span_ms?: number;
	};
};

export function connectLocalizationSocket(
	onEvent: (event: LocalizationEvent) => void,
) {
	let ws: WebSocket;

	function connect() {
		ws = new WebSocket(viteWsUrl());

		ws.onmessage = (event) => {
			const msg = JSON.parse(event.data);
			if (msg.type === "localization_event") {
				onEvent(msg.data as LocalizationEvent);
			}
		};

		ws.onclose = () => {
			setTimeout(connect, 2000);
		};
	}

	connect();

	return () => ws.close();
}
