import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useCallback, useEffect, useMemo, useState } from "react";
import { Label } from "#/components/ui/label";
import {
	NativeSelect,
	NativeSelectOption,
} from "#/components/ui/native-select";
import { startContinuousConclusionFireworks } from "#/lib/conclusion-confetti";
import {
	fetchConclusionCurrent,
	fetchPublicTours,
	type ConclusionPayload,
	type PublicTourRow,
} from "#/lib/tour-kiosk-api";

const UUID_RE =
	/^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

const REFRESH_MS = 30_000;

function formatDurationMs(ms: number): string {
	if (ms <= 0) return "0s";
	const totalSec = Math.floor(ms / 1000);
	const h = Math.floor(totalSec / 3600);
	const m = Math.floor((totalSec % 3600) / 60);
	const s = totalSec % 60;
	if (h > 0) return `${h}h ${m}m ${s}s`;
	if (m > 0) return `${m}m ${s}s`;
	return `${s}s`;
}

function formatWhen(iso: string): string {
	const d = new Date(iso);
	if (Number.isNaN(d.getTime())) return "";
	return d.toLocaleString("en-US", {
		timeZone: "America/Chicago",
		month: "short",
		day: "numeric",
		hour: "numeric",
		minute: "2-digit",
	});
}

function tourOptionLabel(t: PublicTourRow): string {
	const start = t.start_time
		? new Date(t.start_time).toLocaleString("en-US", {
				timeZone: "America/Chicago",
				month: "short",
				day: "numeric",
				hour: "numeric",
				minute: "2-digit",
			})
		: "No start time";
	return `${t.company} · ${start} CST`;
}

export const Route = createFileRoute("/conclusion")({
	ssr: false,
	validateSearch: (search: Record<string, unknown>) => ({
		tour: typeof search.tour === "string" ? search.tour : "",
	}),
	component: ConclusionPage,
});

function ConclusionPage() {
	const navigate = useNavigate();
	const { tour: tourFromUrl } = Route.useSearch();
	const [tours, setTours] = useState<PublicTourRow[]>([]);
	const [toursError, setToursError] = useState<string | null>(null);
	const [payload, setPayload] = useState<ConclusionPayload | null>(null);
	const [loading, setLoading] = useState(true);
	const [error, setError] = useState<string | null>(null);
	const [pickerOpen, setPickerOpen] = useState(false);

	const overrideFromUrl = useMemo(() => {
		return tourFromUrl && UUID_RE.test(tourFromUrl) ? tourFromUrl : undefined;
	}, [tourFromUrl]);

	const load = useCallback(async (override?: string, silent?: boolean) => {
		if (!silent) {
			setLoading(true);
		}
		if (!silent) {
			setError(null);
		}
		try {
			const data = await fetchConclusionCurrent(override);
			setPayload(data);
			setError(null);
		} catch (e) {
			if (!silent) {
				setPayload(null);
				setError(e instanceof Error ? e.message : "Could not load");
			}
		} finally {
			if (!silent) {
				setLoading(false);
			}
		}
	}, []);

	useEffect(() => {
		void load(overrideFromUrl, false);
	}, [load, overrideFromUrl]);

	useEffect(() => {
		const id = window.setInterval(() => {
			void load(overrideFromUrl, true);
		}, REFRESH_MS);
		return () => window.clearInterval(id);
	}, [load, overrideFromUrl]);

	useEffect(() => {
		let cancelled = false;
		(async () => {
			try {
				const list = await fetchPublicTours();
				if (!cancelled) {
					setTours(list);
					setToursError(null);
				}
			} catch (e) {
				if (!cancelled) {
					setToursError(
						e instanceof Error ? e.message : "Could not load tours",
					);
				}
			}
		})();
		return () => {
			cancelled = true;
		};
	}, []);

	const sortedTours = useMemo(
		() =>
			[...tours].sort((a, b) => {
				const ta = a.start_time ? new Date(a.start_time).getTime() : 0;
				const tb = b.start_time ? new Date(b.start_time).getTime() : 0;
				return ta - tb;
			}),
		[tours],
	);

	function onTourChange(nextId: string) {
		void navigate({
			to: "/conclusion",
			search: { tour: nextId },
			replace: true,
		});
	}

	const tour = payload?.tour;

	useEffect(() => {
		if (!payload?.tour?.id) return;
		return startContinuousConclusionFireworks();
	}, [payload?.tour?.id]);

	return (
		<main className="flex min-h-[100dvh] min-w-0 w-full flex-col bg-background">
			<div className="mx-auto w-full max-w-7xl shrink-0 px-6 pb-2 pt-8 sm:px-8 sm:pt-10 md:px-10 md:pt-10 md:pb-2 lg:px-12 lg:pt-11">
				<div className="text-center">
					<h1 className="w-full text-balance text-center text-5xl font-medium tracking-tight text-foreground sm:text-6xl md:text-7xl lg:text-8xl lg:leading-[1.05]">
						Thank you for attending!
					</h1>
				</div>
			</div>

			<div className="mx-auto flex w-full max-w-7xl flex-1 flex-col gap-8 px-6 py-10 sm:px-8 md:px-10 lg:px-12">
				{error?.includes("No tours") ? (
					<div className="mx-auto max-w-xl border border-border bg-muted/25 px-6 py-10 text-center">
						<p className="text-lg text-muted-foreground">
							Tour information isn&apos;t available right now. Please check back
							shortly.
						</p>
					</div>
				) : error ? (
					<div className="mx-auto max-w-xl border border-border bg-muted/25 px-6 py-8 text-center">
						<p className="text-destructive">{error}</p>
					</div>
				) : loading && !payload ? (
					<p className="text-center text-lg text-muted-foreground">Loading…</p>
				) : payload && tour ? (
					<>
						<section className="border border-border bg-card/50 p-6 sm:p-8">
							<div className="flex flex-wrap items-center justify-center gap-x-4 gap-y-3 text-center text-lg text-muted-foreground">
								<div className="flex min-w-0 flex-wrap items-center justify-center gap-3">
									{tour.logo ? (
										<img
											src={tour.logo}
											alt=""
											className="h-12 w-auto max-h-14 max-w-xs shrink-0 object-contain object-center sm:h-14"
											loading="lazy"
											decoding="async"
										/>
									) : null}
									<span className="min-w-0 text-xl font-bold text-foreground sm:text-2xl">
										{tour.company}
									</span>
								</div>
								{tour.start_time ? (
									<span className="w-full text-base sm:w-auto sm:text-lg">
										<span className="text-muted-foreground">· Tour started at </span>
										<span className="text-foreground">
											{new Date(tour.start_time).toLocaleString("en-US", {
												timeZone: "America/Chicago",
											})}{" "}
											CST
										</span>
									</span>
								) : null}
							</div>
						</section>

						<section className="border border-border bg-muted/20">
							<div className="border-b border-border bg-muted/40 px-4 py-3 sm:px-6">
								<p className="text-base font-semibold text-foreground">
									Time at each station
								</p>
								<p className="mt-1 text-sm text-muted-foreground">
									Approximate time your group spent at each stop. Updates every 30
									seconds.
								</p>
							</div>

							<div className="p-4 sm:p-6">
								{payload.stations.length === 0 ? (
									<p className="text-center text-lg text-muted-foreground">
										No station scans for this group yet.
									</p>
								) : (
									<ul className="flex flex-col gap-3">
										{payload.stations.map((row) => (
											<li
												key={row.reader_id}
												className="flex min-w-0 flex-col gap-2 border border-border bg-background/80 px-4 py-4 sm:flex-row sm:flex-wrap sm:items-center sm:justify-between sm:gap-4 sm:py-5"
											>
												<div className="min-w-0 flex-1 border-l-4 border-primary pl-4">
													<p className="text-lg font-semibold text-foreground">
														{row.label}
													</p>
													<p className="mt-1 text-sm text-muted-foreground">
														{formatWhen(row.first_ts)} – {formatWhen(row.last_ts)}{" "}
														CST
													</p>
												</div>
												<p className="shrink-0 border border-border bg-muted/40 px-4 py-2 text-xl font-semibold tabular-nums text-foreground sm:text-2xl">
													{formatDurationMs(row.duration_ms)}
												</p>
											</li>
										))}
									</ul>
								)}
							</div>
						</section>

						<div className="border-t border-border pt-6">
							<button
								type="button"
								className="flex w-full items-center justify-between gap-2 border border-border bg-muted/20 px-4 py-3 text-left text-sm font-medium text-foreground transition-colors hover:bg-muted/35"
								onClick={() => setPickerOpen((o) => !o)}
								aria-expanded={pickerOpen}
							>
								<span>Choose a different tour</span>
								<span className="tabular-nums text-muted-foreground">
									{pickerOpen ? "−" : "+"}
								</span>
							</button>
							{pickerOpen ? (
								<div className="mt-3 flex flex-col gap-3 border border-t-0 border-border bg-muted/15 p-4">
									<Label htmlFor="conclusion-tour" className="text-foreground">
										Tour
									</Label>
									{toursError ? (
										<p className="text-sm text-destructive">{toursError}</p>
									) : (
										<NativeSelect
											id="conclusion-tour"
											className="min-h-12 w-full rounded-none border-border bg-background text-base"
											value={tour.id}
											onChange={(e) => onTourChange(e.target.value)}
										>
											{sortedTours.length > 0 ? (
												sortedTours.map((t) => (
													<NativeSelectOption key={t.id} value={t.id}>
														{tourOptionLabel(t)}
													</NativeSelectOption>
												))
											) : (
												<NativeSelectOption value={t.id}>
													{tour.company}
												</NativeSelectOption>
											)}
										</NativeSelect>
									)}
								</div>
							) : null}
						</div>
					</>
				) : null}
			</div>
		</main>
	);
}
