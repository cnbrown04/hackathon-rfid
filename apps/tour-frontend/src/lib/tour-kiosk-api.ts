/**
 * Public HTTP APIs for kiosk screens (no admin auth).
 * Used by /welcome (WebSocket elsewhere) and /conclusion.
 */

const API_BASE = import.meta.env.VITE_API_URL ?? "http://localhost:3002";

const UUID_RE =
	/^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export type PublicTourRow = {
	id: string;
	company: string;
	logo: string | null;
	ambassador_id: number | null;
	start_time: string | null;
	created_at: string;
};

export async function fetchPublicTours(): Promise<PublicTourRow[]> {
	const r = await fetch(`${API_BASE}/api/tours`);
	if (!r.ok) {
		const msg = await parseJsonError(r);
		throw new Error(msg);
	}
	return r.json() as Promise<PublicTourRow[]>;
}

export type TourStationSummaryRow = {
	reader_id: string;
	label: string;
	first_ts: string;
	last_ts: string;
	duration_ms: number;
	event_count: number;
};

export type TourStationSummary = {
	tour: {
		id: string;
		company: string;
		logo: string | null;
		start_time: string | null;
	};
	stations: TourStationSummaryRow[];
};

export type ConclusionSelection = {
	mode: "current" | "override";
	reason: "active" | "upcoming" | "latest_created" | null;
};

export type ConclusionPayload = TourStationSummary & {
	selection: ConclusionSelection;
};

export async function fetchTourStationSummary(
	tourId: string,
): Promise<TourStationSummary> {
	if (!UUID_RE.test(tourId)) {
		throw new Error("Invalid tour");
	}
	const q = new URLSearchParams({ tour_id: tourId });
	const r = await fetch(`${API_BASE}/api/tour-station-summary?${q.toString()}`);
	if (!r.ok) {
		const msg = await parseJsonError(r);
		throw new Error(msg);
	}
	return r.json() as Promise<TourStationSummary>;
}

/** Current tour for the thank-you screen (server picks active tour unless `tourId` overrides). */
export async function fetchConclusionCurrent(
	tourIdOverride?: string,
): Promise<ConclusionPayload> {
	const q = new URLSearchParams();
	if (tourIdOverride && UUID_RE.test(tourIdOverride)) {
		q.set("tour_id", tourIdOverride);
	}
	const url = q.toString()
		? `${API_BASE}/api/conclusion-current?${q.toString()}`
		: `${API_BASE}/api/conclusion-current`;
	const r = await fetch(url);
	if (!r.ok) {
		const msg = await parseJsonError(r);
		throw new Error(msg);
	}
	return r.json() as Promise<ConclusionPayload>;
}

async function parseJsonError(r: Response): Promise<string> {
	try {
		const j = (await r.json()) as { error?: string };
		return j.error ?? r.statusText;
	} catch {
		return r.statusText;
	}
}
