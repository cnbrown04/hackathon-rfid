import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useMemo, useRef, useState } from "react";
import {
	connectLocalizationSocket,
	type LocalizeEvent,
} from "#/lib/localization-data";
import { cn } from "#/lib/utils";

export const Route = createFileRoute("/localization")({
	component: LocalizationPage,
});

const GRID_FT = 6;

const ANCHORS = [
	{ id: 1, label: "Antenna 1", x: 0, y: 0 },
	{ id: 2, label: "Antenna 2", x: GRID_FT / 2, y: GRID_FT },
	{ id: 3, label: "Antenna 3", x: GRID_FT, y: 0 },
] as const;

const ANCHOR_POS: Record<number, { x: number; y: number }> = {
	1: { x: 0, y: 0 },
	2: { x: GRID_FT / 2, y: GRID_FT },
	3: { x: GRID_FT, y: 0 },
};

function estimatePosition(
	antennas: Map<number, { rssi: number | null; readCount: number | null; ts: string }>,
): { x: number; y: number } | null {
	let wx = 0;
	let wy = 0;
	let wSum = 0;
	for (const [antId, read] of antennas) {
		const pos = ANCHOR_POS[antId];
		if (!pos) continue;
		let weight: number;
		if (read.rssi != null && Number.isFinite(read.rssi)) {
			weight = 10 ** (read.rssi / 10);
		} else if (read.readCount != null && read.readCount > 0) {
			weight = read.readCount;
		} else {
			weight = 1;
		}
		wx += pos.x * weight;
		wy += pos.y * weight;
		wSum += weight;
	}
	if (wSum === 0) return null;
	const x = wx / wSum;
	const y = wy / wSum;
	if (x < -1 || x > GRID_FT + 1 || y < -1 || y > GRID_FT + 1) return null;
	return { x: Math.max(0, Math.min(GRID_FT, x)), y: Math.max(0, Math.min(GRID_FT, y)) };
}

function ftToPct(ft: number): number {
	return (ft / GRID_FT) * 100;
}

function fmt(v: number | null | undefined): string {
	return v == null || Number.isNaN(v) ? "--" : v.toFixed(1);
}

type TagState = {
	epc: string;
	antennas: Map<number, { rssi: number | null; readCount: number | null; ts: string }>;
	lastSeen: string;
	totalReads: number;
};

const TAG_COLORS = [
	"#f43f5e",
	"#3b82f6",
	"#22c55e",
	"#f59e0b",
	"#a855f7",
	"#06b6d4",
	"#ec4899",
	"#14b8a6",
];

function colorForIndex(i: number): string {
	return TAG_COLORS[i % TAG_COLORS.length];
}

const ANTENNA_COLORS: Record<number, string> = {
	1: "#38bdf8",
	2: "#34d399",
	3: "#fbbf24",
};

function LocalizationPage() {
	const [tagMap, setTagMap] = useState<Map<string, TagState>>(() => new Map());
	const [selectedEpc, setSelectedEpc] = useState<string | null>(null);
	const [connected, setConnected] = useState(false);
	const [eventCount, setEventCount] = useState(0);
	const epcOrderRef = useRef<string[]>([]);

	useEffect(() => {
		const disconnect = connectLocalizationSocket((event) => {
			if (!connected) setConnected(true);
			setEventCount((n) => n + 1);

			setTagMap((prev) => {
				const next = new Map(prev);
				const existing = next.get(event.epc);
				const antennas = existing?.antennas ?? new Map();
				if (event.antenna_id != null) {
					antennas.set(event.antenna_id, {
						rssi: event.avg_rssi,
						readCount: event.read_count,
						ts: event.event_ts,
					});
				}
				next.set(event.epc, {
					epc: event.epc,
					antennas,
					lastSeen: event.event_ts,
					totalReads: (existing?.totalReads ?? 0) + 1,
				});
				return next;
			});

			if (!epcOrderRef.current.includes(event.epc)) {
				epcOrderRef.current = [...epcOrderRef.current, event.epc];
			}
			setSelectedEpc((cur) => cur ?? event.epc);
		});
		return disconnect;
	}, [connected]);

	const tags = useMemo(() => Array.from(tagMap.values()), [tagMap]);
	const selectedTag = selectedEpc ? tagMap.get(selectedEpc) ?? null : null;

	return (
		<div className="flex min-h-[100dvh] flex-col bg-[#0a0a0f] text-white">
			{/* Header */}
			<header className="flex shrink-0 items-center justify-between border-b border-white/[0.06] px-6 py-4 md:px-10">
				<div className="flex items-center gap-3">
					<div className="flex size-8 items-center justify-center rounded-md bg-white/[0.06]">
						<svg viewBox="0 0 24 24" className="size-4 text-white/60" fill="none" stroke="currentColor" strokeWidth="2">
							<path d="M2 12h2m16 0h2M12 2v2m0 16v2" />
							<circle cx="12" cy="12" r="4" />
							<circle cx="12" cy="12" r="8" strokeDasharray="4 4" />
						</svg>
					</div>
					<div>
						<h1 className="text-sm font-semibold tracking-tight">RFID Localization</h1>
						<p className="text-xs text-white/40">Live antenna reads</p>
					</div>
				</div>
				<div className="flex items-center gap-4">
					{eventCount > 0 && (
						<span className="text-xs tabular-nums text-white/30">
							{eventCount} events
						</span>
					)}
					<div className="flex items-center gap-2">
						<div
							className={cn(
								"size-2 rounded-full",
								connected ? "bg-emerald-400 shadow-[0_0_6px_1px_#34d39955]" : "bg-white/20",
							)}
						/>
						<span className="text-xs text-white/40">
							{connected ? "Live" : "Waiting"}
						</span>
					</div>
				</div>
			</header>

			<div className="flex min-h-0 flex-1 flex-col lg:flex-row">
				{/* Map area */}
				<div className="flex flex-1 items-center justify-center p-6 md:p-10">
					<div className="relative aspect-square w-full max-w-[min(80vh,800px)]">
						{/* Grid */}
						<div className="absolute inset-0 rounded-lg border border-white/[0.08] bg-white/[0.02]">
							{[1, 2, 3, 4, 5].map((i) => (
								<div
									key={`v-${i}`}
									className="absolute top-0 bottom-0 border-l border-white/[0.04]"
									style={{ left: `${(i / 6) * 100}%` }}
								/>
							))}
							{[1, 2, 3, 4, 5].map((i) => (
								<div
									key={`h-${i}`}
									className="absolute right-0 left-0 border-t border-white/[0.04]"
									style={{ top: `${(i / 6) * 100}%` }}
								/>
							))}
						</div>

						{/* Axis labels */}
						<span className="absolute -bottom-5 left-0 text-[10px] text-white/25">0</span>
						<span className="absolute -bottom-5 right-0 text-[10px] text-white/25">6 ft</span>
						<span className="absolute -left-5 bottom-0 text-[10px] text-white/25">0</span>
						<span className="absolute -left-5 top-0 text-[10px] text-white/25">6</span>

						{/* Antenna anchors with activity pulse */}
						{ANCHORS.map((a) => {
							const hasRead = selectedTag?.antennas.has(a.id);
							return (
								<div
									key={a.id}
									className="absolute -translate-x-1/2 -translate-y-1/2"
									style={{
										left: `${ftToPct(a.x)}%`,
										top: `${100 - ftToPct(a.y)}%`,
									}}
								>
									{hasRead && (
										<div
											className="absolute inset-0 -m-2 animate-ping rounded-full opacity-30"
											style={{ backgroundColor: ANTENNA_COLORS[a.id] }}
										/>
									)}
									<div
										className={cn(
											"flex size-8 items-center justify-center rounded-full border backdrop-blur-sm transition-all duration-300",
											hasRead
												? "border-white/30 bg-white/[0.1]"
												: "border-white/10 bg-white/[0.04]",
										)}
									>
										<span className="text-[11px] font-bold text-white/70">{a.id}</span>
									</div>
									<span className="absolute left-1/2 top-full mt-2 -translate-x-1/2 whitespace-nowrap text-[9px] font-medium tracking-wide text-white/30 uppercase">
										{a.label}
									</span>
									{selectedTag?.antennas.has(a.id) && (
										<span
											className="absolute right-full top-1/2 mr-2 -translate-y-1/2 whitespace-nowrap font-mono text-[10px]"
											style={{ color: ANTENNA_COLORS[a.id] }}
										>
											{fmt(selectedTag.antennas.get(a.id)?.rssi)} dBm
										</span>
									)}
								</div>
							);
						})}

						{/* Tag position dots */}
						{tags.map((tag) => {
							const pos = estimatePosition(tag.antennas);
							if (!pos) return null;
							const idx = epcOrderRef.current.indexOf(tag.epc);
							const isSelected = tag.epc === selectedEpc;
							const color = colorForIndex(idx);
							return (
								<button
									key={tag.epc}
									type="button"
									onClick={() => setSelectedEpc(tag.epc)}
									className="absolute -translate-x-1/2 -translate-y-1/2 transition-all duration-[1.5s] ease-[cubic-bezier(0.25,0.1,0.25,1)]"
									style={{
										left: `${ftToPct(pos.x)}%`,
										top: `${100 - ftToPct(pos.y)}%`,
									}}
								>
									<div
										className={cn(
											"size-16 rounded-full shadow-lg transition-transform duration-200",
											isSelected && "scale-[1.4] ring-2 ring-white/80",
										)}
										style={{ backgroundColor: color, boxShadow: `0 0 14px 4px ${color}44` }}
									/>
									<span className="absolute left-1/2 top-full mt-1 -translate-x-1/2 whitespace-nowrap text-[10px] font-medium text-white/60">
										{tag.epc.slice(-4)}
									</span>
								</button>
							);
						})}

						{/* Empty state */}
						{tags.length === 0 && (
							<div className="absolute inset-0 flex flex-col items-center justify-center gap-3">
								<div className="flex items-center gap-2">
									{[0, 1, 2].map((i) => (
										<div
											key={i}
											className="size-1.5 animate-pulse rounded-full bg-white/20"
											style={{ animationDelay: `${i * 200}ms` }}
										/>
									))}
								</div>
								<p className="text-sm text-white/25">Waiting for localize reader events</p>
							</div>
						)}
					</div>
				</div>

				{/* Side panel */}
				<aside className="flex w-full shrink-0 flex-col border-t border-white/[0.06] lg:w-80 lg:border-t-0 lg:border-l xl:w-96">
					<div className="border-b border-white/[0.06] px-5 py-3">
						<p className="text-xs font-medium tracking-wide text-white/40 uppercase">
							Detected tags
							{tags.length > 0 && (
								<span className="ml-2 text-white/60">{tags.length}</span>
							)}
						</p>
					</div>
					<div className="flex-1 overflow-y-auto">
						{tags.length === 0 ? (
							<div className="px-5 py-8 text-center text-xs text-white/20">
								No tags detected yet
							</div>
						) : (
							<ul className="divide-y divide-white/[0.04]">
								{tags.map((tag) => {
									const idx = epcOrderRef.current.indexOf(tag.epc);
									const isActive = tag.epc === selectedEpc;
									return (
										<li key={tag.epc}>
											<button
												type="button"
												onClick={() => setSelectedEpc(tag.epc)}
												className={cn(
													"flex w-full items-start gap-3 px-5 py-3.5 text-left transition-colors",
													isActive
														? "bg-white/[0.04]"
														: "hover:bg-white/[0.02]",
												)}
											>
												<div
													className="mt-1 size-3 shrink-0 rounded-full"
													style={{ backgroundColor: colorForIndex(idx) }}
												/>
												<div className="min-w-0 flex-1">
													<p className="truncate font-mono text-xs text-white/80">
														{tag.epc}
													</p>
													<div className="mt-1.5 flex flex-col gap-1">
														{[1, 2, 3].map((antId) => {
															const read = tag.antennas.get(antId);
															return (
																<div key={antId} className="flex items-center gap-2 text-[11px]">
																	<span
																		className="inline-block size-1.5 rounded-full"
																		style={{
																			backgroundColor: read
																				? ANTENNA_COLORS[antId]
																				: "rgba(255,255,255,0.1)",
																		}}
																	/>
																	<span className="text-white/30">A{antId}</span>
																	{read ? (
																		<>
																			<span className="tabular-nums text-white/60">
																				{fmt(read.rssi)} dBm
																			</span>
																			{read.readCount != null && (
																				<span className="text-white/25">
																					{read.readCount} reads
																				</span>
																			)}
																		</>
																	) : (
																		<span className="text-white/15">--</span>
																	)}
																</div>
															);
														})}
													</div>
													<p className="mt-1 text-[10px] text-white/20">
														{tag.totalReads} total events
													</p>
												</div>
											</button>
										</li>
									);
								})}
							</ul>
						)}
					</div>
				</aside>
			</div>
		</div>
	);
}
