import { createFileRoute, useRouter } from "@tanstack/react-router";
import { useCallback, useEffect, useState } from "react";
import { formatNameSingleLine } from "#/components/person-name";
import {
	AlertDialog,
	AlertDialogCancel,
	AlertDialogContent,
	AlertDialogDescription,
	AlertDialogFooter,
	AlertDialogHeader,
	AlertDialogTitle,
} from "#/components/ui/alert-dialog";
import { Avatar, AvatarFallback, AvatarImage } from "#/components/ui/avatar";
import { Button } from "#/components/ui/button";
import { Label } from "#/components/ui/label";
import {
	NativeSelect,
	NativeSelectOption,
} from "#/components/ui/native-select";
import {
	Table,
	TableBody,
	TableCell,
	TableHead,
	TableHeader,
	TableRow,
} from "#/components/ui/table";
import {
	Tooltip,
	TooltipContent,
	TooltipProvider,
	TooltipTrigger,
} from "#/components/ui/tooltip";
import {
	deleteAllTourEvents,
	fetchTourEvents,
	loadAdminListData,
	type PersonRow,
	simulateTourEvent,
	type TourEventListRow,
} from "#/lib/admin-api";

const READER_OPTIONS = [
	{ value: "welcome", label: "welcome (welcome / tour roster)" },
	{ value: "reader-1", label: "reader-1" },
	{ value: "lidar", label: "lidar (shelf)" },
] as const;

export const Route = createFileRoute("/admin/simulate")({
	ssr: false,
	beforeLoad: async () => loadAdminListData(),
	pendingComponent: AdminSimulatePending,
	component: SimulateTourEvent,
});

function AdminSimulatePending() {
	return <div className="text-muted-foreground">Loading…</div>;
}

function formatEventTs(iso: string): string {
	const d = new Date(iso);
	if (Number.isNaN(d.getTime())) return iso;
	return d.toLocaleString("en-US", { timeZone: "America/Chicago" });
}

function personDisplayName(ev: TourEventListRow): string {
	return formatNameSingleLine(
		ev.person_first_name ?? "",
		ev.person_last_name ?? "",
	);
}

function personLabel(p: PersonRow): string {
	return `${formatNameSingleLine(p.first_name, p.last_name)} — ${p.epc}`;
}

function EventPersonCell({ ev }: { ev: TourEventListRow }) {
	const name = personDisplayName(ev);
	const hasPerson = ev.person_id != null && Boolean(name.trim());

	return (
		<Tooltip>
			<TooltipTrigger asChild>
				<button
					type="button"
					className="block w-full min-w-0 text-left text-[11px] text-foreground underline-offset-2 hover:underline focus-visible:ring-1 focus-visible:ring-ring focus-visible:outline-none"
				>
					<span className="whitespace-nowrap">{hasPerson ? name : "—"}</span>
				</button>
			</TooltipTrigger>
			<TooltipContent
				side="top"
				className="max-w-[280px] flex-col gap-3 rounded-none p-3 text-left"
			>
				{hasPerson ? (
					<div className="flex gap-3">
						<Avatar className="size-10 shrink-0 rounded-none border border-background/20">
							{ev.person_photo_url ? (
								<AvatarImage
									src={ev.person_photo_url}
									alt={name ? `${name} profile` : "Profile"}
								/>
							) : null}
							<AvatarFallback className="rounded-none bg-background/15 text-xs text-background">
								{(ev.person_first_name?.[0] ?? "?") +
									(ev.person_last_name?.[0] ?? "")}
							</AvatarFallback>
						</Avatar>
						<div className="min-w-0 space-y-1">
							<p className="font-medium whitespace-nowrap leading-tight">
								{name}
							</p>
							{ev.person_role ? (
								<p className="text-[10px] text-background/80 uppercase tracking-wide">
									{ev.person_role}
								</p>
							) : null}
							{ev.person_email ? (
								<p className="truncate text-[11px] text-background/85">
									{ev.person_email}
								</p>
							) : null}
							{ev.person_company ? (
								<p className="truncate text-[11px]">{ev.person_company}</p>
							) : null}
							{ev.person_title ? (
								<p className="text-[11px] text-background/80">
									{ev.person_title}
								</p>
							) : null}
							{ev.epc ? (
								<p className="font-mono text-[10px] whitespace-nowrap text-background/70">
									{ev.epc}
								</p>
							) : null}
						</div>
					</div>
				) : (
					<p className="text-[11px] leading-snug text-background/90">
						No person with this EPC in People. Add them under{" "}
						<span className="font-medium text-background">People</span> to link
						scans.
					</p>
				)}
			</TooltipContent>
		</Tooltip>
	);
}

function SimulateTourEvent() {
	const router = useRouter();
	const { people, loadError } = Route.useRouteContext();
	const [personId, setPersonId] = useState("");
	const [readerId, setReaderId] = useState<string>(READER_OPTIONS[0].value);
	const [busy, setBusy] = useState(false);
	const [lastResult, setLastResult] = useState<string | null>(null);
	const [error, setError] = useState<string | null>(null);
	const [events, setEvents] = useState<TourEventListRow[]>([]);
	const [eventsError, setEventsError] = useState<string | null>(null);
	const [deleteOpen, setDeleteOpen] = useState(false);

	const refreshEvents = useCallback(async () => {
		setEventsError(null);
		try {
			setEvents(await fetchTourEvents());
		} catch (e) {
			setEventsError(e instanceof Error ? e.message : "Failed to load events");
		}
	}, []);

	useEffect(() => {
		void refreshEvents();
	}, [refreshEvents]);

	const sorted = [...people].sort((a, b) =>
		`${a.last_name} ${a.first_name}`.localeCompare(
			`${b.last_name} ${b.first_name}`,
		),
	);

	async function onSend() {
		const id = Number.parseInt(personId, 10);
		if (!personId || Number.isNaN(id)) {
			setError("Choose a person");
			return;
		}
		setBusy(true);
		setError(null);
		setLastResult(null);
		try {
			const row = await simulateTourEvent({
				person_id: id,
				reader_id: readerId,
			});
			const eid = row.event_id != null ? String(row.event_id) : "?";
			setLastResult(`Inserted event ${eid}`);
			await refreshEvents();
			void router.invalidate();
		} catch (e) {
			setError(e instanceof Error ? e.message : "Request failed");
		} finally {
			setBusy(false);
		}
	}

	async function onDeleteAll() {
		setDeleteOpen(false);
		setEventsError(null);
		try {
			await deleteAllTourEvents();
			await refreshEvents();
		} catch (e) {
			setEventsError(e instanceof Error ? e.message : "Delete failed");
		}
	}

	return (
		<TooltipProvider delayDuration={200}>
			<div className="flex min-w-0 flex-col gap-8">
				<div>
					<h1 className="text-xl font-semibold tracking-tight">
						Simulate tour event
					</h1>
					<p className="mt-1 max-w-prose text-sm text-muted-foreground">
						Writes the same <code className="text-xs">tour_event</code> row as
						POST <code className="text-xs">/event</code> — nothing extra in the
						browser. The server fills <code className="text-xs">tour_id</code>{" "}
						the same way as the welcome flow: for ambassadors, the tour whose{" "}
						<code className="text-xs">start_time</code> is nearest to now; for
						visitors, their <code className="text-xs">people.tour_id</code>. The
						Postgres listener turns the insert into WebSocket messages; keep{" "}
						<code className="text-xs">/welcome</code> open to see it. Use{" "}
						<code className="text-xs">welcome</code> for the welcome flow.{" "}
						<code className="text-xs">lidar</code> triggers a{" "}
						<code className="text-xs">lidar_items</code> lookup by the
						person&apos;s EPC and broadcasts <code className="text-xs">lidar_scan</code>{" "}
						(open <code className="text-xs">/lidar</code>; add rows under{" "}
						<code className="text-xs">LiDAR items</code> in admin).
					</p>
				</div>

				<section className="w-full rounded-none border border-border bg-card/30 p-4 sm:p-6">
					<h2 className="mb-4 text-sm font-medium">Send fake event</h2>
					{loadError ? (
						<p className="text-sm text-destructive">{loadError}</p>
					) : (
						<div className="flex min-w-0 flex-col gap-6">
							<div className="flex min-w-0 flex-col gap-4 lg:flex-row lg:flex-wrap lg:items-end">
								<div className="flex min-w-0 flex-1 flex-col gap-2">
									<Label htmlFor="sim-person">Person</Label>
									<NativeSelect
										id="sim-person"
										className="w-full min-w-0"
										value={personId}
										onChange={(e) => setPersonId(e.target.value)}
									>
										<NativeSelectOption value="">
											Select a person…
										</NativeSelectOption>
										{sorted.map((p) => (
											<NativeSelectOption key={p.id} value={String(p.id)}>
												{personLabel(p)}
											</NativeSelectOption>
										))}
									</NativeSelect>
								</div>
								<div className="flex min-w-0 flex-col gap-2 lg:w-56">
									<Label htmlFor="sim-reader">Reader</Label>
									<NativeSelect
										id="sim-reader"
										className="w-full min-w-0"
										value={readerId}
										onChange={(e) => setReaderId(e.target.value)}
									>
										{READER_OPTIONS.map((opt) => (
											<NativeSelectOption key={opt.value} value={opt.value}>
												{opt.label}
											</NativeSelectOption>
										))}
									</NativeSelect>
								</div>
								<div className="flex w-full shrink-0 lg:w-auto">
									<Button
										type="button"
										className="w-full lg:w-auto"
										disabled={busy || people.length === 0}
										onClick={onSend}
									>
										{busy ? "Sending…" : "Send fake event"}
									</Button>
								</div>
							</div>
							{people.length === 0 ? (
								<p className="text-sm text-muted-foreground">
									Add people under People first.
								</p>
							) : null}
							{error ? (
								<p className="text-sm text-destructive">{error}</p>
							) : null}
							{lastResult ? (
								<p className="text-sm text-muted-foreground">{lastResult}</p>
							) : null}
						</div>
					)}
				</section>

				<div className="min-w-0 space-y-3">
					<div className="flex flex-wrap items-center justify-between gap-3">
						<h2 className="text-sm font-medium">Recent tour events</h2>
						<div className="flex flex-wrap gap-2">
							<Button
								type="button"
								variant="outline"
								size="sm"
								className="rounded-none"
								onClick={() => void refreshEvents()}
							>
								Refresh
							</Button>
							<Button
								type="button"
								variant="outline"
								size="sm"
								className="rounded-none"
								onClick={() => setDeleteOpen(true)}
								disabled={events.length === 0}
							>
								Delete all
							</Button>
						</div>
					</div>
					{eventsError ? (
						<p className="text-sm text-destructive">{eventsError}</p>
					) : null}
					{events.length === 0 && !eventsError ? (
						<p className="text-sm text-muted-foreground">No events yet.</p>
					) : null}
					{events.length > 0 ? (
						<div className="h-[min(40vh,320px)] w-full overflow-auto rounded-none border border-border">
							<Table>
								<TableHeader>
									<TableRow>
										<TableHead className="w-[1%] whitespace-nowrap text-[11px]">
											Time (CST)
										</TableHead>
										<TableHead className="text-[11px]">Type</TableHead>
										<TableHead className="min-w-32 text-[11px]">EPC</TableHead>
										<TableHead className="text-[11px]">Person</TableHead>
										<TableHead className="text-[11px]">Tour</TableHead>
										<TableHead className="text-[11px]">Reader</TableHead>
									</TableRow>
								</TableHeader>
								<TableBody>
									{events.map((ev) => (
										<TableRow key={String(ev.id)}>
											<TableCell className="whitespace-nowrap text-[11px] text-muted-foreground">
												{formatEventTs(ev.event_ts)}
											</TableCell>
											<TableCell className="whitespace-nowrap text-[11px]">
												{ev.event_type}
											</TableCell>
											<TableCell className="whitespace-nowrap font-mono text-[10px]">
												{ev.epc ?? "—"}
											</TableCell>
											<TableCell className="whitespace-nowrap">
												<EventPersonCell ev={ev} />
											</TableCell>
											<TableCell className="whitespace-nowrap font-mono text-[10px] text-muted-foreground">
												{ev.tour_id ?? "—"}
											</TableCell>
											<TableCell className="whitespace-nowrap font-mono text-[11px]">
												{ev.reader_id ?? "—"}
											</TableCell>
										</TableRow>
									))}
								</TableBody>
							</Table>
						</div>
					) : null}
				</div>

				<AlertDialog open={deleteOpen} onOpenChange={setDeleteOpen}>
					<AlertDialogContent className="w-[min(100vw-2rem,28rem)] rounded-none sm:max-w-md">
						<AlertDialogHeader>
							<AlertDialogTitle>Delete all tour events?</AlertDialogTitle>
							<AlertDialogDescription>
								This clears the tour_event table (development / reset). This
								cannot be undone.
							</AlertDialogDescription>
						</AlertDialogHeader>
						<AlertDialogFooter>
							<AlertDialogCancel className="rounded-none">
								Cancel
							</AlertDialogCancel>
							<Button
								type="button"
								variant="destructive"
								className="rounded-none"
								onClick={onDeleteAll}
							>
								Delete all
							</Button>
						</AlertDialogFooter>
					</AlertDialogContent>
				</AlertDialog>
			</div>
		</TooltipProvider>
	);
}
