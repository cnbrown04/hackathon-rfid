import { PLACEHOLDER_EPC } from "#/lib/welcome-data";

/** One tag read at a specific antenna (test data — replace with live SSE / polling). */
export type AntennaReadEvent = {
	antennaId: string;
	antennaLabel: string;
	userName: string;
	epc: string;
};

/** Ordered reads: each item appears as the “next page” in the stepper. */
export const TEST_ANTENNA_READS: AntennaReadEvent[] = [
	{
		antennaId: "ANT-01",
		antennaLabel: "Main entrance",
		userName: "Ada Lovelace",
		epc: PLACEHOLDER_EPC,
	},
	{
		antennaId: "ANT-02",
		antennaLabel: "Lab floor",
		userName: "Grace Hopper",
		epc: "E28069950000500CA794A480",
	},
	{
		antennaId: "ANT-03",
		antennaLabel: "Equipment bay",
		userName: "Margaret Hamilton",
		epc: "E28069950000500CA794A481",
	},
	{
		antennaId: "ANT-04",
		antennaLabel: "Exit corridor",
		userName: "Katherine Johnson",
		epc: "E28069950000500CA794A482",
	},
];

export const ANTENNA_FLOW_TIMING = {
	/** Wait before the first read appears (ms). */
	initialDelayMs: 2200,
	/** How long each read stays before auto-advancing (ms). */
	stepHoldMs: 6000,
} as const;
