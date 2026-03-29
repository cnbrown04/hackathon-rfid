import confetti from "canvas-confetti";

/** Auburn orange & navy — aligned with welcome confetti */
const AUBURN_ORANGE = "#E87722";
const AUBURN_NAVY = "#0C2340";
const AUBURN_ORANGE_SOFT = "#F4A84A";

const COLORS = [AUBURN_ORANGE, AUBURN_NAVY, AUBURN_ORANGE_SOFT, "#f8fafc"];

/** Time between each wave of fireworks */
const INTERVAL_MS = 3000;

function r(min: number, max: number): number {
	return min + Math.random() * (max - min);
}

/**
 * “Shell” burst in the sky — random position, wide spherical spray (fireworks-like).
 */
function skyShellBurst(opts: {
	colors: string[];
}): void {
	const x = r(0.06, 0.94);
	const y = r(0.08, 0.52);
	void confetti({
		colors: opts.colors,
		particleCount: Math.floor(r(70, 130)),
		spread: r(260, 360),
		startVelocity: r(16, 36),
		ticks: Math.floor(r(240, 340)),
		gravity: r(0.82, 1.12),
		scalar: r(0.82, 1.02),
		decay: r(0.88, 0.94),
		origin: { x, y },
		shapes: ["square", "circle"],
	});
}

/**
 * Ground salute — random spot along the bottom, fanning upward.
 */
function groundSalute(opts: { colors: string[] }): void {
	const x = r(0.04, 0.96);
	const y = r(0.84, 0.98);
	void confetti({
		colors: opts.colors,
		particleCount: Math.floor(r(45, 95)),
		spread: r(42, 78),
		startVelocity: r(26, 48),
		angle: r(55, 125),
		ticks: Math.floor(r(180, 260)),
		gravity: r(0.95, 1.12),
		scalar: r(0.85, 0.98),
		origin: { x, y },
		shapes: ["square", "circle"],
	});
}

/**
 * Quick side flicker from a random edge (extra variety).
 */
function edgeSpark(opts: { colors: string[] }): void {
	const fromLeft = Math.random() > 0.5;
	const x = fromLeft ? r(0.02, 0.12) : r(0.88, 0.98);
	const y = r(0.2, 0.75);
	void confetti({
		colors: opts.colors,
		particleCount: Math.floor(r(25, 55)),
		spread: r(35, 65),
		startVelocity: r(14, 28),
		angle: fromLeft ? r(35, 70) : r(110, 145),
		ticks: Math.floor(r(160, 240)),
		gravity: r(0.9, 1.08),
		origin: { x, y },
		shapes: ["square", "circle"],
	});
}

/**
 * Repeated fireworks-style waves while the thank-you page is open.
 * Each wave uses random positions, mixes sky shells + ground bursts + occasional edge sparks.
 */
export function startContinuousConclusionFireworks(): () => void {
	if (typeof window === "undefined") return () => {};
	if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
		return () => {};
	}

	const palette = COLORS;
	const pendingTimeouts: number[] = [];

	function clearPendingTimeouts() {
		for (const id of pendingTimeouts) {
			window.clearTimeout(id);
		}
		pendingTimeouts.length = 0;
	}

	function wave() {
		clearPendingTimeouts();
		/** 2–5 sub-bursts per wave, staggered so they don’t all originate together */
		const subBursts = 2 + Math.floor(Math.random() * 4);
		for (let i = 0; i < subBursts; i++) {
			const delay = i * r(45, 220);
			const id = window.setTimeout(() => {
				const roll = Math.random();
				if (roll < 0.52) {
					skyShellBurst({ colors: palette });
				} else if (roll < 0.88) {
					groundSalute({ colors: palette });
				} else {
					edgeSpark({ colors: palette });
				}
			}, delay);
			pendingTimeouts.push(id);
		}
	}

	wave();
	const intervalId = window.setInterval(wave, INTERVAL_MS);

	return () => {
		window.clearInterval(intervalId);
		clearPendingTimeouts();
	};
}
