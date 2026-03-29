export type LidarProduct = {
	epc: string;
	upc: string;
	item_url: string | null;
	item_desc: string;
};

import { viteWsUrl } from "./env-urls";

export function connectLidarSocket(onProduct: (product: LidarProduct) => void) {
	let ws: WebSocket;

	function connect() {
		ws = new WebSocket(viteWsUrl());

		ws.onopen = () => {
			console.log("[lidar] WebSocket connected to", viteWsUrl());
		};

		ws.onmessage = (event) => {
			const msg = JSON.parse(event.data);
			console.log("[lidar] WS message received:", msg.type, msg.data ?? "");
			if (msg.type === "lidar_scan") {
				console.log("[lidar] Product detected:", msg.data.item_desc, "EPC:", msg.data.epc);
				onProduct(msg.data as LidarProduct);
			}
		};

		ws.onclose = () => {
			console.log("[lidar] WebSocket closed, reconnecting in 2s...");
			setTimeout(connect, 2000);
		};

		ws.onerror = (err) => {
			console.error("[lidar] WebSocket error:", err);
		};
	}

	connect();

	return () => ws.close();
}
