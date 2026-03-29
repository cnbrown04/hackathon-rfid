import { createFileRoute } from "@tanstack/react-router";
import { useReducedMotion } from "framer-motion";
import { useEffect, useRef, useState } from "react";
import { formatNameSingleLine } from "#/components/person-name";
import { Avatar, AvatarFallback, AvatarImage } from "#/components/ui/avatar";
import { Card, CardHeader, CardTitle } from "#/components/ui/card";
import { RfidLabHeadingLine } from "#/components/rfid-lab-heading";
import { cn } from "#/lib/utils";
import { burstAuburnWelcomeConfettiAtEpc } from "#/lib/welcome-confetti";
import {
	connectWelcomeSocket,
	type TourRosterPayload,
	type WelcomeUser,
} from "#/lib/welcome-data";

function formatTimeRead(iso: string): string {
	const d = new Date(iso);
	if (Number.isNaN(d.getTime())) return "";
	return `${d.toLocaleString("en-US", {
		timeZone: "America/Chicago",
		month: "short",
		day: "numeric",
		hour: "numeric",
		minute: "2-digit",
		second: "2-digit",
	})} CST`;
}

function TimeReadLine({ iso }: { iso: string | null | undefined }) {
	if (!iso) return null;
	const formatted = formatTimeRead(iso);
	if (!formatted) return null;
	return (
		<p className="text-sm text-muted-foreground">
			<span className="text-foreground/90">Time read</span> {formatted}
		</p>
	);
}

/** 6-dot braille by approximate “fill” level (blank → full) */
const BRAILLE_LEVELS = ["\u2800", "\u2801", "\u2803", "\u2807", "\u280f", "\u281f", "\u283f"];

const BRAILLE_ROWS = 7;
const BRAILLE_COLS = 26;

function BrailleWaveMatrix({ paused }: { paused: boolean }) {
	const [tick, setTick] = useState(0);

	useEffect(() => {
		if (paused) return;
		const id = window.setInterval(() => {
			setTick((n) => (n + 1) % 10_000);
		}, 95);
		return () => window.clearInterval(id);
	}, [paused]);

	const t = paused ? 0 : tick;
	const lines: string[] = [];

	for (let r = 0; r < BRAILLE_ROWS; r++) {
		let line = "";
		for (let c = 0; c < BRAILLE_COLS; c++) {
			const a = Math.sin(c * 0.42 + r * 0.61 + t * 0.22);
			const b = Math.sin(c * 0.31 - r * 0.48 + t * 0.18);
			const intensity = (a * 0.55 + b * 0.45 + 1) / 2;
			const idx = Math.min(
				BRAILLE_LEVELS.length - 1,
				Math.floor(intensity * BRAILLE_LEVELS.length),
			);
			line += BRAILLE_LEVELS[idx];
		}
		lines.push(line);
	}

	return (
		<pre
			className="mx-auto mb-2 block w-full min-w-0 overflow-hidden text-center font-mono leading-none tracking-tight text-primary/85 [font-variant-ligatures:none]"
			// Fits BRAILLE_COLS across the viewport (or max-w-2xl column) without horizontal scroll
			style={{
				fontSize: `min(1.4rem, calc((min(100vw, 42rem) - 3rem) / ${BRAILLE_COLS}))`,
			}}
			aria-hidden
		>
			{lines.join("\n")}
		</pre>
	);
}

function AmbassadorWaitingCue() {
	const reduceMotion = useReducedMotion();

	return (
		<div className="flex min-w-0 max-w-2xl flex-col items-center px-2 text-center">
			<div className="w-full min-w-0 overflow-hidden select-none">
				<BrailleWaveMatrix paused={reduceMotion ?? false} />
			</div>
			<p className="text-balance text-2xl font-medium tracking-tight text-foreground sm:text-3xl">
				Waiting on the ambassador
			</p>
			<p className="mt-4 text-balance text-sm leading-relaxed text-muted-foreground sm:text-base">
				Their scan opens the tour on this screen—hang tight.
			</p>
		</div>
	);
}

export const Route = createFileRoute("/welcome")({
	component: Welcome,
});

function Welcome() {
	const [roster, setRoster] = useState<TourRosterPayload | null>(null);
	const [arrivalTimes, setArrivalTimes] = useState<Map<string, string>>(
		() => new Map(),
	);
	const [legacyUsers, setLegacyUsers] = useState<WelcomeUser[]>([]);
	const rosterActiveRef = useRef(false);
	const seenLegacyEpc = useRef(new Set<string>());
	const prevRosterArrivalKeysRef = useRef<Set<string>>(new Set());
	const lastTourIdRef = useRef<string | null>(null);
	const prevLegacyEpcSetRef = useRef<Set<string>>(new Set());

	useEffect(() => {
		const disconnect = connectWelcomeSocket({
			onTourRoster: (payload) => {
				rosterActiveRef.current = true;
				setRoster(payload);
				const scannedAt =
					payload.scanned_at && payload.scanned_at.length > 0
						? payload.scanned_at
						: new Date().toISOString();
				setArrivalTimes(new Map([[payload.scanned_epc, scannedAt]]));
				setLegacyUsers([]);
				seenLegacyEpc.current = new Set();
			},
			onWelcome: (user) => {
				if (rosterActiveRef.current) {
					setArrivalTimes((prev) => {
						const next = new Map(prev);
						next.set(user.epc, user.arrived_at);
						return next;
					});
					return;
				}
				if (seenLegacyEpc.current.has(user.epc)) return;
				seenLegacyEpc.current.add(user.epc);
				setLegacyUsers((prev) => [...prev, user]);
			},
			onWelcomeClear: () => {
				rosterActiveRef.current = false;
				setRoster(null);
				setLegacyUsers([]);
				setArrivalTimes(new Map());
				seenLegacyEpc.current = new Set();
			},
		});
		return disconnect;
	}, []);

	const hasRosterLayout = roster !== null;
	const showRosterGrid = roster !== null && roster.people.length > 0;
	const showLegacy = !hasRosterLayout && legacyUsers.length > 0;

	useEffect(() => {
		if (showRosterGrid && roster) {
			if (lastTourIdRef.current !== roster.tour_id) {
				lastTourIdRef.current = roster.tour_id;
				prevRosterArrivalKeysRef.current = new Set();
			}
			const rosterEpcs = new Set(roster.people.map((p) => p.epc));
			let newArrivalEpc: string | null = null;
			for (const epc of arrivalTimes.keys()) {
				if (
					!prevRosterArrivalKeysRef.current.has(epc) &&
					rosterEpcs.has(epc)
				) {
					newArrivalEpc = epc;
					break;
				}
			}
			if (newArrivalEpc !== null) {
				const epc = newArrivalEpc;
				requestAnimationFrame(() => {
					burstAuburnWelcomeConfettiAtEpc(epc);
				});
			}
			prevRosterArrivalKeysRef.current = new Set(arrivalTimes.keys());
			prevLegacyEpcSetRef.current = new Set();
			return;
		}

		if (showLegacy) {
			lastTourIdRef.current = null;
			prevRosterArrivalKeysRef.current = new Set();
			let newLegacyEpc: string | null = null;
			for (const u of legacyUsers) {
				if (!prevLegacyEpcSetRef.current.has(u.epc)) {
					newLegacyEpc = u.epc;
					break;
				}
			}
			if (newLegacyEpc !== null) {
				const epc = newLegacyEpc;
				requestAnimationFrame(() => {
					burstAuburnWelcomeConfettiAtEpc(epc);
				});
			}
			prevLegacyEpcSetRef.current = new Set(legacyUsers.map((u) => u.epc));
			return;
		}

		lastTourIdRef.current = null;
		prevRosterArrivalKeysRef.current = new Set();
		prevLegacyEpcSetRef.current = new Set();
	}, [showRosterGrid, showLegacy, roster, arrivalTimes, legacyUsers]);
	const showWaiting = !hasRosterLayout && !showLegacy;

	const cardsSection =
		showRosterGrid || showLegacy ? (
			<div className="w-full px-4 pb-8 sm:px-5 sm:pb-10 md:px-6 lg:px-8">
				<div className="rounded-none border border-border/60 bg-muted/25 p-2 sm:p-3 md:p-3.5">
					{showRosterGrid && roster ? (
						<ul className="grid grid-cols-1 gap-3 sm:grid-cols-2 sm:gap-4 md:grid-cols-2 lg:grid-cols-3 lg:gap-4 xl:grid-cols-4 xl:gap-4 2xl:grid-cols-5 2xl:gap-4">
						{roster.people.map((user) => {
							const arrived = arrivalTimes.has(user.epc);
							const readIso = arrivalTimes.get(user.epc);
							return (
								<li key={user.epc} className="min-w-0">
									<Card
										className={cn(
											"h-full py-4 transition-opacity duration-300 sm:py-5",
											!arrived && "opacity-40",
										)}
									>
										<CardHeader className="gap-2 px-4 sm:gap-3 sm:px-5 md:px-6">
											<Avatar className="size-14 sm:size-16 md:size-[4.25rem]">
												{user.photo_url ? (
													<AvatarImage
														src={user.photo_url}
														alt={formatNameSingleLine(
															user.first_name,
															user.last_name,
														)}
													/>
												) : null}
												<AvatarFallback className="text-lg md:text-xl">
													{user.first_name[0]}
													{user.last_name[0]}
												</AvatarFallback>
											</Avatar>
											<CardTitle className="text-xl font-semibold sm:text-2xl md:text-[1.65rem] lg:text-3xl">
												<span
													className="whitespace-nowrap"
													data-welcome-name-anchor={user.epc}
												>
													{formatNameSingleLine(
														user.first_name,
														user.last_name,
													)}
												</span>
											</CardTitle>
											{user.email ? (
												<p className="text-sm text-muted-foreground">
													{user.email}
												</p>
											) : null}
											<TimeReadLine iso={readIso} />
											<div className="overflow-x-auto">
												<p className="whitespace-nowrap font-mono text-xs leading-snug sm:text-sm">
													<span className="text-muted-foreground">EPC </span>
													<span className="text-foreground">{user.epc}</span>
												</p>
											</div>
										</CardHeader>
									</Card>
								</li>
							);
						})}
						</ul>
					) : null}
					{showLegacy ? (
						<ul className="grid grid-cols-1 gap-3 sm:grid-cols-2 sm:gap-4 md:grid-cols-2 lg:grid-cols-3 lg:gap-4 xl:grid-cols-4 xl:gap-4 2xl:grid-cols-5 2xl:gap-4">
						{legacyUsers.map((user) => (
							<li key={user.epc} className="min-w-0">
								<Card className="h-full py-4 sm:py-5">
									<CardHeader className="gap-2 px-4 sm:gap-3 sm:px-5 md:px-6">
										<Avatar className="size-14 sm:size-16 md:size-[4.25rem]">
											{user.photo_url ? (
												<AvatarImage
													src={user.photo_url}
													alt={formatNameSingleLine(
														user.first_name,
														user.last_name,
													)}
												/>
											) : null}
											<AvatarFallback className="text-lg md:text-xl">
												{user.first_name[0]}
												{user.last_name[0]}
											</AvatarFallback>
										</Avatar>
										<CardTitle className="text-xl font-semibold sm:text-2xl md:text-[1.65rem] lg:text-3xl">
											<span
												className="whitespace-nowrap"
												data-welcome-name-anchor={user.epc}
											>
												{formatNameSingleLine(user.first_name, user.last_name)}
											</span>
										</CardTitle>
										{user.email ? (
											<p className="text-sm text-muted-foreground">
												{user.email}
											</p>
										) : null}
										<TimeReadLine iso={user.arrived_at} />
										<div className="overflow-x-auto">
											<p className="whitespace-nowrap font-mono text-xs leading-snug sm:text-sm">
												<span className="text-muted-foreground">EPC </span>
												<span className="text-foreground">{user.epc}</span>
											</p>
										</div>
									</CardHeader>
								</Card>
							</li>
						))}
						</ul>
					) : null}
				</div>
			</div>
		) : null;

	return (
		<main className="flex min-h-[100dvh] min-w-0 w-full flex-col">
			<div className="mx-auto w-full max-w-7xl shrink-0 px-6 pb-2 pt-8 sm:px-8 sm:pt-10 md:px-10 md:pt-10 md:pb-2 lg:px-12 lg:pt-11">
				<div className="text-center">
					<h1 className="w-full text-center text-5xl font-medium tracking-tight text-foreground sm:text-6xl md:text-7xl lg:text-8xl lg:leading-[1.05]">
						<RfidLabHeadingLine />
					</h1>
					{roster ? (
						<div className="mt-3 flex flex-wrap items-center justify-center gap-x-4 gap-y-2 pb-5 text-center text-lg text-muted-foreground sm:pb-6">
							<div className="flex min-w-0 flex-wrap items-center justify-center gap-3">
								{roster.logo ? (
									<img
										src={roster.logo}
										alt=""
										className="h-10 w-auto max-h-12 max-w-xs shrink-0 object-contain object-center"
										loading="lazy"
										decoding="async"
									/>
								) : null}
								<span className="min-w-0 font-bold text-foreground">
									{roster.company}
								</span>
							</div>
							{roster.start_time ? (
								<span className="text-base sm:text-lg">
									· Tour start{" "}
									{new Date(roster.start_time).toLocaleString("en-US", {
										timeZone: "America/Chicago",
									})}{" "}
									CST
								</span>
							) : null}
						</div>
					) : null}
				</div>

				{hasRosterLayout && roster && roster.people.length === 0 ? (
					<p className="mt-6 text-center text-lg text-muted-foreground">
						No participants assigned to this tour yet.
					</p>
				) : null}
			</div>

			{showWaiting ? (
				<div className="flex min-w-0 w-full flex-1 flex-col items-center justify-center px-6 py-12 pb-20">
					<AmbassadorWaitingCue />
				</div>
			) : null}

			{cardsSection}
		</main>
	);
}
