const API_BASE = import.meta.env.VITE_API_URL ?? "http://localhost:3002";

const STORAGE_KEY = "rfid-lab-admin-secret";

export const TOUR_ROLES = ["visitor", "ambassador"] as const;
export type TourRole = (typeof TOUR_ROLES)[number];

export type PersonRow = {
	id: number;
	epc: string;
	first_name: string;
	last_name: string;
	email: string | null;
	company: string | null;
	title: string | null;
	photo_url: string | null;
	created_at: string;
	role: TourRole;
	tour_id: string | null;
};

export type TourRow = {
	id: string;
	company: string;
	ambassador_id: number | null;
	start_time: string | null;
	created_at: string;
};

export function getAdminSecret(): string | null {
	if (typeof sessionStorage === "undefined") return null;
	return sessionStorage.getItem(STORAGE_KEY);
}

export function setAdminSecret(secret: string) {
	sessionStorage.setItem(STORAGE_KEY, secret);
}

export function clearAdminSecret() {
	sessionStorage.removeItem(STORAGE_KEY);
}

export async function login(password: string): Promise<boolean> {
	const r = await fetch(`${API_BASE}/api/admin/login`, {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify({ password }),
	});
	return r.ok;
}

function authHeaders(): HeadersInit {
	const secret = getAdminSecret();
	if (!secret) throw new Error("Not authenticated");
	return {
		Authorization: `Bearer ${secret}`,
		"Content-Type": "application/json",
	};
}

async function parseError(r: Response): Promise<string> {
	try {
		const j = (await r.json()) as { error?: string };
		return j.error ?? r.statusText;
	} catch {
		return r.statusText;
	}
}

export async function fetchPeople(): Promise<PersonRow[]> {
	const r = await fetch(`${API_BASE}/api/admin/people`, {
		headers: authHeaders(),
	});
	if (!r.ok) throw new Error(await parseError(r));
	return r.json() as Promise<PersonRow[]>;
}

export async function createPerson(
	body: Omit<PersonRow, "id" | "created_at">,
): Promise<PersonRow> {
	const r = await fetch(`${API_BASE}/api/admin/people`, {
		method: "POST",
		headers: authHeaders(),
		body: JSON.stringify(body),
	});
	if (!r.ok) throw new Error(await parseError(r));
	return r.json() as Promise<PersonRow>;
}

export async function updatePerson(
	id: number,
	body: Omit<PersonRow, "id" | "created_at">,
): Promise<PersonRow> {
	const r = await fetch(`${API_BASE}/api/admin/people/${id}`, {
		method: "PUT",
		headers: authHeaders(),
		body: JSON.stringify(body),
	});
	if (!r.ok) throw new Error(await parseError(r));
	return r.json() as Promise<PersonRow>;
}

export async function deletePerson(id: number): Promise<void> {
	const r = await fetch(`${API_BASE}/api/admin/people/${id}`, {
		method: "DELETE",
		headers: authHeaders(),
	});
	if (!r.ok) throw new Error(await parseError(r));
}

export async function fetchTours(): Promise<TourRow[]> {
	const r = await fetch(`${API_BASE}/api/admin/tours`, {
		headers: authHeaders(),
	});
	if (!r.ok) throw new Error(await parseError(r));
	return r.json() as Promise<TourRow[]>;
}

export async function createTour(body: {
	company: string;
	ambassador_id?: number | null;
	start_time?: string | null;
}): Promise<TourRow> {
	const r = await fetch(`${API_BASE}/api/admin/tours`, {
		method: "POST",
		headers: authHeaders(),
		body: JSON.stringify(body),
	});
	if (!r.ok) throw new Error(await parseError(r));
	return r.json() as Promise<TourRow>;
}

export async function updateTour(
	id: string,
	body: {
		company: string;
		ambassador_id?: number | null;
		start_time?: string | null;
	},
): Promise<TourRow> {
	const r = await fetch(`${API_BASE}/api/admin/tours/${id}`, {
		method: "PUT",
		headers: authHeaders(),
		body: JSON.stringify(body),
	});
	if (!r.ok) throw new Error(await parseError(r));
	return r.json() as Promise<TourRow>;
}

export async function deleteTour(id: string): Promise<void> {
	const r = await fetch(`${API_BASE}/api/admin/tours/${id}`, {
		method: "DELETE",
		headers: authHeaders(),
	});
	if (!r.ok) throw new Error(await parseError(r));
}

/** Fetches people + tours for admin route loaders. */
export type AdminListData = {
	people: PersonRow[];
	tours: TourRow[];
	loadError: string | null;
};

export async function loadAdminListData(): Promise<AdminListData> {
	if (typeof window === "undefined") {
		return { people: [], tours: [], loadError: null };
	}
	try {
		const [people, tours] = await Promise.all([fetchPeople(), fetchTours()]);
		return { people, tours, loadError: null };
	} catch (e) {
		return {
			people: [],
			tours: [],
			loadError: e instanceof Error ? e.message : "Failed to load",
		};
	}
}
