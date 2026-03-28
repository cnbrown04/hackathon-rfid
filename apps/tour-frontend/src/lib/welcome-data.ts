/** Placeholder EPC until tags are read from the reader / API. */
export const PLACEHOLDER_EPC = "E28069950000500CA794A479";

export type LabUser = { id: string; name: string; epc: string };

export type WelcomePayload = {
	companyName: string;
	users: LabUser[];
};

const TEST_WELCOME: WelcomePayload = {
	companyName: "Acme Corp",
	users: [
		{ id: "1", name: "Ada Lovelace", epc: PLACEHOLDER_EPC },
		{ id: "2", name: "Grace Hopper", epc: PLACEHOLDER_EPC },
		{ id: "3", name: "Margaret Hamilton", epc: PLACEHOLDER_EPC },
		{ id: "4", name: "Katherine Johnson", epc: PLACEHOLDER_EPC },
	],
};

/**
 * Stand-in for a backend call. Replace the body with `fetch(...)` when the API is ready.
 */
export async function fetchWelcomeLabData(): Promise<WelcomePayload> {
	await new Promise((r) => setTimeout(r, 0));
	return structuredClone(TEST_WELCOME);
}
