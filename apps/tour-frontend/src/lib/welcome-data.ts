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

const WS_URL = "ws://localhost:3001";

export function connectWelcomeSocket(onUser: (user: WelcomeUser) => void) {
	let ws: WebSocket;

	function connect() {
		ws = new WebSocket(WS_URL);

		ws.onmessage = (event) => {
			const msg = JSON.parse(event.data);
			if (msg.type === "welcome") {
				onUser(msg.data as WelcomeUser);
			}
		};

		ws.onclose = () => {
			setTimeout(connect, 2000);
		};
	}

	connect();

	return () => ws.close();
}
