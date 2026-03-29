import { createFileRoute } from "@tanstack/react-router";
import { Radio } from "lucide-react";
import { useEffect, useMemo, useState } from "react";
import { Badge } from "#/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "#/components/ui/card";
import {
	connectLocalizationSocket,
	type LocalizationEvent,
} from "#/lib/localization-data";

export const Route = createFileRoute("/antenna")({
	component: AntennaLocalizationRoute,
});

const GRID_SIZE_FT = 6;

const ANCHORS = [
	{ id: 1, label: "localization-1", x: 0, y: 0 },
	{ id: 2, label: "localization-2", x: 6, y: 0 },
	{ id: 3, label: "localization-3", x: 3, y: 6 },
] as const;

function AntennaLocalizationRoute() {
	const [events, setEvents] = useState<LocalizationEvent[]>([]);
	const [selectedEpc, setSelectedEpc] = useState<string>("");

	useEffect(() => {
		const disconnect = connectLocalizationSocket((event) => {
			setEvents((prev) => {
				const next = [event, ...prev.filter((row) => row.id !== event.id)].slice(0, 40);
				setSelectedEpc((current) =>
					!current || current === event.epc ? event.epc : current,
				);
				return next;
			});
		});
		return disconnect;
	}, []);

	const latestByEpc = useMemo(() => {
		const map = new Map<string, LocalizationEvent>();
		for (const event of events) {
			if (!map.has(event.epc)) {
				map.set(event.epc, event);
			}
		}
		return Array.from(map.values());
	}, [events]);

	const selectedEvent = useMemo(() => {
		if (selectedEpc) {
			const found = latestByEpc.find((event) => event.epc === selectedEpc);
			if (found) return found;
		}
		return latestByEpc[0] || null;
	}, [latestByEpc, selectedEpc]);

	return (
		<main className="min-h-[100dvh] bg-gradient-to-br from-background via-background to-muted/35 px-4 py-8 md:px-8 md:py-10">
			<div className="mx-auto flex w-full max-w-6xl flex-col gap-6">
				<header className="flex flex-wrap items-end justify-between gap-3">
					<div className="space-y-2">
						<p className="flex items-center gap-2 text-sm font-medium tracking-wide text-muted-foreground uppercase">
							<Radio className="size-4 text-primary" />
							Live trilateration
						</p>
						<h1 className="text-3xl font-semibold tracking-tight md:text-4xl">
							Antenna localization map
						</h1>
					</div>
					<Badge variant={events.length > 0 ? "default" : "outline"}>
						{events.length > 0 ? "Streaming from websocket" : "Waiting for events"}
					</Badge>
				</header>

				<div className="grid gap-4 lg:grid-cols-[1.2fr_1fr]">
					<Card>
						<CardHeader>
							<CardTitle className="flex items-center justify-between gap-2 text-lg">
								<span>6x6 ft floor map</span>
								{selectedEvent ? (
									<Badge variant="secondary">EPC {selectedEvent.epc}</Badge>
								) : null}
							</CardTitle>
						</CardHeader>
						<CardContent>
							<MapCanvas selectedEvent={selectedEvent} />
						</CardContent>
					</Card>

					<Card>
						<CardHeader>
							<CardTitle className="text-lg">Recent localization events</CardTitle>
						</CardHeader>
						<CardContent className="space-y-2">
							{latestByEpc.length === 0 ? (
								<p className="text-sm text-muted-foreground">
									No localization points yet. Send tour events from antennas 1, 2,
									and 3.
								</p>
							) : (
								<ul className="space-y-2">
									{latestByEpc.map((event) => (
										<li key={event.event_id}>
											<button
												type="button"
												onClick={() => setSelectedEpc(event.epc)}
												className="w-full rounded-md border bg-muted/30 px-3 py-2 text-left transition hover:bg-muted/50"
											>
												<p className="truncate font-mono text-xs">{event.epc}</p>
												<p className="mt-1 text-xs text-muted-foreground">
													x={fmt(event.x_ft)} ft · y={fmt(event.y_ft)} ft · conf={" "}
													{fmtPct(event.confidence)}
												</p>
												<p className="text-xs text-muted-foreground">
													{new Date(event.event_ts).toLocaleTimeString()}
												</p>
											</button>
										</li>
									))}
								</ul>
							)}
						</CardContent>
					</Card>
				</div>
			</div>
		</main>
	);
}

function MapCanvas({ selectedEvent }: { selectedEvent: LocalizationEvent | null }) {
	const tagLeft =
		selectedEvent?.x_ft == null
			? null
			: `${(selectedEvent.x_ft / GRID_SIZE_FT) * 100}%`;
	const tagTop =
		selectedEvent?.y_ft == null
			? null
			: `${100 - (selectedEvent.y_ft / GRID_SIZE_FT) * 100}%`;

	return (
		<div className="relative mx-auto aspect-square w-full max-w-2xl rounded-xl border border-border bg-[linear-gradient(to_right,var(--border)_1px,transparent_1px),linear-gradient(to_bottom,var(--border)_1px,transparent_1px)] bg-[size:16.666%_16.666%] bg-muted/20">
			{ANCHORS.map((anchor) => {
				const left = `${(anchor.x / GRID_SIZE_FT) * 100}%`;
				const top = `${100 - (anchor.y / GRID_SIZE_FT) * 100}%`;
				return (
					<div
						key={anchor.id}
						className="absolute -translate-x-1/2 -translate-y-1/2"
						style={{ left, top }}
					>
						<div className="size-3 rounded-full bg-primary ring-4 ring-primary/20" />
						<p className="mt-1 -translate-x-1/2 text-center text-[10px] text-muted-foreground">
							{anchor.label}
						</p>
					</div>
				);
			})}

			{selectedEvent ? (
				<>
					<RadiusCircle anchor={ANCHORS[0]} radiusFt={selectedEvent.r1_ft} color="border-sky-400/60" />
					<RadiusCircle anchor={ANCHORS[1]} radiusFt={selectedEvent.r2_ft} color="border-emerald-400/60" />
					<RadiusCircle anchor={ANCHORS[2]} radiusFt={selectedEvent.r3_ft} color="border-amber-400/60" />
				</>
			) : null}

			{tagLeft && tagTop ? (
				<div
					className="absolute -translate-x-1/2 -translate-y-1/2"
					style={{ left: tagLeft, top: tagTop }}
				>
					<div className="size-4 rounded-full bg-red-500 shadow-[0_0_0_8px_color-mix(in_oklab,var(--color-red-500)_20%,transparent)]" />
				</div>
			) : null}

			<div className="absolute right-2 bottom-2 rounded bg-background/80 px-2 py-1 text-xs text-muted-foreground">
				0..6 ft
			</div>
		</div>
	);
}

function RadiusCircle({
	anchor,
	radiusFt,
	color,
}: {
	anchor: (typeof ANCHORS)[number];
	radiusFt: number | null;
	color: string;
}) {
	if (radiusFt == null) return null;
	const diameterPct = (radiusFt * 2 * 100) / GRID_SIZE_FT;
	const left = `${(anchor.x / GRID_SIZE_FT) * 100}%`;
	const top = `${100 - (anchor.y / GRID_SIZE_FT) * 100}%`;
	return (
		<div
			className={`pointer-events-none absolute -translate-x-1/2 -translate-y-1/2 rounded-full border border-dashed ${color}`}
			style={{
				left,
				top,
				width: `${diameterPct}%`,
				height: `${diameterPct}%`,
			}}
		/>
	);
}

function fmt(value: number | null): string {
	if (value == null || Number.isNaN(value)) return "--";
	return value.toFixed(2);
}

function fmtPct(value: number | null): string {
	if (value == null || Number.isNaN(value)) return "--";
	return `${Math.round(value * 100)}%`;
}
