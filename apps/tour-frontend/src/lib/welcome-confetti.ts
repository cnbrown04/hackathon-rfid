import confetti from "canvas-confetti";

/** Matches `data-welcome-name-anchor` on the name `<span>` in welcome cards */
export const WELCOME_NAME_ANCHOR = "data-welcome-name-anchor";

/** Auburn orange & navy — official-adjacent brand colors for light bursts */
const AUBURN_ORANGE = "#E87722";
const AUBURN_NAVY = "#0C2340";
const AUBURN_ORANGE_SOFT = "#F4A84A";

function normalizedViewportOrigin(el: Element): { x: number; y: number } {
	const r = el.getBoundingClientRect();
	const w = Math.max(window.innerWidth, 1);
	const h = Math.max(window.innerHeight, 1);
	const x = (r.left + r.width / 2) / w;
	const y = (r.top + r.height / 2) / h;
	return {
		x: Math.min(1, Math.max(0, x)),
		y: Math.min(1, Math.max(0, y)),
	};
}

/**
 * Confetti burst anchored to a user's name on the welcome screen (`data-welcome-name-anchor`).
 * Falls back to upper-center if the node is missing. Respects `prefers-reduced-motion`.
 */
export function burstAuburnWelcomeConfettiAtEpc(epc: string): void {
	if (typeof window === "undefined") return;
	if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

	const el = document.querySelector(
		`[${WELCOME_NAME_ANCHOR}="${CSS.escape(epc)}"]`,
	);
	const origin = el
		? normalizedViewportOrigin(el)
		: { x: 0.5, y: 0.38 };

	const colors = [AUBURN_ORANGE, AUBURN_NAVY, AUBURN_ORANGE_SOFT];
	const base = {
		spread: 58,
		startVelocity: 28,
		gravity: 0.92,
		ticks: 130,
		scalar: 0.88,
		origin,
		colors,
	};

	void confetti({
		...base,
		particleCount: 72,
	});
	void confetti({
		...base,
		particleCount: 38,
		spread: 72,
		startVelocity: 22,
		ticks: 100,
	});
}
