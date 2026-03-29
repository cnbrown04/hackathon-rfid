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

		ws.onmessage = (event) => {
			const msg = JSON.parse(event.data);
			if (msg.type === "lidar_scan") {
				onProduct(msg.data as LidarProduct);
			}
		};

		ws.onclose = () => {
			setTimeout(connect, 2000);
		};
	}

	connect();

	return () => ws.close();
}
