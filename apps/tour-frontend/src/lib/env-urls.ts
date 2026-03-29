/** WebSocket URL for API real-time streams (same host/port as HTTP API when deployed). */
export function viteWsUrl(): string {
	const explicit = import.meta.env.VITE_WS_URL;
	if (typeof explicit === "string" && explicit.length > 0) {
		return explicit;
	}
	const api = import.meta.env.VITE_API_URL;
	if (typeof api === "string" && api.startsWith("https://")) {
		return api.replace(/^https/, "wss");
	}
	if (typeof api === "string" && api.startsWith("http://")) {
		return api.replace(/^http/, "ws");
	}
	return "ws://localhost:3002";
}
