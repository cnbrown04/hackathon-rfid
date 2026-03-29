import { createFileRoute, Link } from "@tanstack/react-router";
import { useCallback, useEffect, useMemo, useState } from "react";
import { formatNameSingleLine } from "#/components/person-name";
import { Button } from "#/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "#/components/ui/card";
import { Input } from "#/components/ui/input";
import { Label } from "#/components/ui/label";
import {
	NativeSelect,
	NativeSelectOption,
} from "#/components/ui/native-select";
import {
	clearWelcomeScreens,
	clearAdminSecret,
	getAdminSecret,
	showConclusionOnWelcomeScreens,
	loadAdminListData,
	login,
	setAdminSecret,
	simulateTourEvent,
	type PersonRow,
	type TourRow,
} from "#/lib/admin-api";

const WELCOME_READER = "welcome";

function tourOptionLabel(t: TourRow): string {
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

export const Route = createFileRoute("/ambassador")({
	ssr: false,
	beforeLoad: async () => loadAdminListData(),
	pendingComponent: AmbassadorPending,
	component: AmbassadorPage,
});

function AmbassadorPending() {
	return (
		<div className="flex min-h-[100dvh] items-center justify-center text-muted-foreground">
			Loading…
		</div>
	);
}

function AmbassadorPage() {
	const { people, tours, loadError } = Route.useRouteContext();
	const [ready, setReady] = useState(false);
	const [loggedIn, setLoggedIn] = useState(false);
	const [password, setPassword] = useState("");
	const [loginError, setLoginError] = useState<string | null>(null);

	const [selectedTourId, setSelectedTourId] = useState<string>("");
	const [busyAction, setBusyAction] = useState<string | null>(null);
	const [feedback, setFeedback] = useState<string | null>(null);
	const [error, setError] = useState<string | null>(null);

	useEffect(() => {
		setLoggedIn(!!getAdminSecret());
		setReady(true);
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

	const selectedTour = useMemo(
		() => sortedTours.find((t) => t.id === selectedTourId) ?? null,
		[sortedTours, selectedTourId],
	);

	const ambassadorForTour = useMemo(() => {
		if (!selectedTour?.ambassador_id) return null;
		return people.find((p) => p.id === selectedTour.ambassador_id) ?? null;
	}, [people, selectedTour]);

	const visitorsOnTour = useMemo(() => {
		if (!selectedTourId) return [];
		return [...people]
			.filter((p) => p.tour_id === selectedTourId && p.role === "visitor")
			.sort((a, b) =>
				`${a.last_name} ${a.first_name}`.localeCompare(
					`${b.last_name} ${b.first_name}`,
				),
			);
	}, [people, selectedTourId]);

	async function onLogin(e: React.FormEvent) {
		e.preventDefault();
		setLoginError(null);
		const ok = await login(password);
		if (ok) {
			setAdminSecret(password);
			setLoggedIn(true);
			setPassword("");
		} else {
			setLoginError("Wrong password");
		}
	}

	function logout() {
		clearAdminSecret();
		setLoggedIn(false);
	}

	const runSimulate = useCallback(
		async (key: string, fn: () => Promise<void>) => {
			setBusyAction(key);
			setError(null);
			setFeedback(null);
			try {
				await fn();
				setFeedback("Sent.");
			} catch (e) {
				setError(e instanceof Error ? e.message : "Request failed");
			} finally {
				setBusyAction(null);
			}
		},
		[],
	);

	async function onLoadTourOnWelcome() {
		if (!selectedTour || !ambassadorForTour) {
			setError("Pick a tour that has an ambassador assigned.");
			return;
		}
		await runSimulate("load", () =>
			simulateTourEvent({
				person_id: ambassadorForTour.id,
				reader_id: WELCOME_READER,
				tour_id: selectedTour.id,
			}),
		);
	}

	async function onSimulateVisitor(p: PersonRow) {
		await runSimulate(`v-${p.id}`, () =>
			simulateTourEvent({
				person_id: p.id,
				reader_id: WELCOME_READER,
			}),
		);
	}

	async function onClearWelcome() {
		setBusyAction("clear");
		setError(null);
		setFeedback(null);
		try {
			await clearWelcomeScreens();
			setFeedback("Welcome screens cleared.");
		} catch (e) {
			setError(e instanceof Error ? e.message : "Clear failed");
		} finally {
			setBusyAction(null);
		}
	}

	if (!ready) {
		return (
			<div className="flex min-h-[100dvh] items-center justify-center text-muted-foreground">
				Loading…
			</div>
		);
	}

	if (!loggedIn) {
		return (
			<main className="mx-auto flex min-h-[100dvh] w-full max-w-md flex-col justify-center gap-8 px-6 py-12">
				<div>
					<h1 className="text-2xl font-semibold tracking-tight">Ambassador</h1>
					<p className="mt-2 text-sm text-muted-foreground">
						iPad control for welcome / tours. Same password as admin.
					</p>
				</div>
				<form onSubmit={onLogin} className="flex flex-col gap-4">
					<div className="space-y-2">
						<Label htmlFor="amb-pw">Password</Label>
						<Input
							id="amb-pw"
							type="password"
							autoComplete="current-password"
							value={password}
							onChange={(e) => setPassword(e.target.value)}
						/>
					</div>
					{loginError ? (
						<p className="text-sm text-destructive">{loginError}</p>
					) : null}
					<Button type="submit" size="lg" className="min-h-12 w-full text-base">
						Sign in
					</Button>
				</form>
				<p className="text-center text-sm text-muted-foreground">
					<Link to="/admin/people" className="underline underline-offset-2">
						Open full admin
					</Link>
				</p>
			</main>
		);
	}

	return (
		<div className="flex min-h-[100dvh] min-w-0 flex-col bg-background">
			<header className="shrink-0 border-b border-border bg-card/50">
				<div className="mx-auto flex max-w-4xl flex-wrap items-center justify-between gap-3 px-4 py-4 sm:px-6">
					<div>
						<h1 className="text-lg font-semibold tracking-tight sm:text-xl">
							Ambassador
						</h1>
						<p className="text-xs text-muted-foreground sm:text-sm">
							Welcome & tour controls
						</p>
					</div>
					<div className="flex flex-wrap items-center gap-2">
						<Button
							type="button"
							variant="outline"
							size="sm"
							className="min-h-11"
							disabled={busyAction !== null}
							onClick={() =>
								void runSimulate("thankYou", () =>
									showConclusionOnWelcomeScreens(
										selectedTourId || null,
									),
								)
							}
						>
							{busyAction === "thankYou"
								? "Sending…"
								: "Show thank you on welcome screens"}
						</Button>
						<Button
							type="button"
							variant="outline"
							size="sm"
							className="min-h-11 min-w-[8rem]"
							onClick={() => void onClearWelcome()}
							disabled={busyAction !== null}
						>
							{busyAction === "clear" ? "Clearing…" : "Clear welcome screens"}
						</Button>
						<Button
							type="button"
							variant="secondary"
							size="sm"
							className="min-h-11"
							onClick={logout}
						>
							Log out
						</Button>
					</div>
				</div>
			</header>

			<div className="mx-auto flex w-full min-w-0 max-w-4xl flex-1 flex-col gap-6 px-4 py-6 sm:px-6 sm:py-8">
						{loadError ? (
							<p className="text-destructive">{loadError}</p>
						) : (
							<div className="flex flex-col gap-6">
								<Card className="rounded-none border-border">
									<CardHeader className="pb-2">
										<CardTitle className="text-base sm:text-lg">
											Tour & ambassador scan
										</CardTitle>
										<p className="text-sm text-muted-foreground">
											Choose a tour, then simulate the ambassador badge read. That
											loads the roster on every{" "}
											<code className="text-xs text-foreground">/welcome</code>{" "}
											screen.
										</p>
									</CardHeader>
									<CardContent className="flex flex-col gap-4">
										<div className="flex flex-col gap-2">
											<Label htmlFor="amb-tour" className="text-base">
												Tour
											</Label>
											<NativeSelect
												id="amb-tour"
												className="min-h-12 w-full text-base"
												value={selectedTourId}
												onChange={(e) => setSelectedTourId(e.target.value)}
											>
												<NativeSelectOption value="">
													Select a tour…
												</NativeSelectOption>
												{sortedTours.map((t) => (
													<NativeSelectOption key={t.id} value={t.id}>
														{tourOptionLabel(t)}
													</NativeSelectOption>
												))}
											</NativeSelect>
										</div>

										{selectedTour ? (
											<div className="rounded-none border border-border/80 bg-muted/30 px-4 py-3 text-sm">
												<p>
													<span className="text-muted-foreground">
														Ambassador:{" "}
													</span>
													{ambassadorForTour ? (
														<span className="font-medium text-foreground">
															{formatNameSingleLine(
																ambassadorForTour.first_name,
																ambassadorForTour.last_name,
															)}
														</span>
													) : (
														<span className="text-amber-600 dark:text-amber-500">
															None assigned — set one in Admin → Tours
														</span>
													)}
												</p>
											</div>
										) : null}

										<Button
											type="button"
											size="lg"
											className="min-h-14 w-full text-base sm:text-lg"
											disabled={
												!selectedTour ||
												!ambassadorForTour ||
												busyAction !== null
											}
											onClick={() => void onLoadTourOnWelcome()}
										>
											{busyAction === "load"
												? "Sending…"
												: "Load tour on welcome screen"}
										</Button>
									</CardContent>
								</Card>

								<Card className="rounded-none border-border">
									<CardHeader className="pb-2">
										<CardTitle className="text-base sm:text-lg">
											Simulate guest arrivals
										</CardTitle>
										<p className="text-sm text-muted-foreground">
											Triggers each person&apos;s badge read on the welcome
											reader (same as a real scan). Assign guests to this tour in
											Admin → People.
										</p>
									</CardHeader>
									<CardContent>
										{!selectedTourId ? (
											<p className="text-sm text-muted-foreground">
												Select a tour above to list people on that tour.
											</p>
										) : visitorsOnTour.length === 0 ? (
											<p className="text-sm text-muted-foreground">
												No people linked to this tour yet.
											</p>
										) : (
											<ul className="flex flex-col gap-2">
												{visitorsOnTour.map((p) => (
													<li
														key={p.id}
														className="flex min-h-[3.25rem] flex-wrap items-center justify-between gap-3 border border-border/60 bg-card/40 px-4 py-3"
													>
														<div className="min-w-0">
															<p className="truncate font-medium">
																{formatNameSingleLine(
																	p.first_name,
																	p.last_name,
																)}
															</p>
															<p className="truncate font-mono text-xs text-muted-foreground">
																{p.epc}
															</p>
														</div>
														<Button
															type="button"
															variant="secondary"
															className="min-h-12 min-w-[9rem] shrink-0"
															disabled={busyAction !== null}
															onClick={() => void onSimulateVisitor(p)}
														>
															{busyAction === `v-${p.id}`
																? "…"
																: "Simulate arrival"}
														</Button>
													</li>
												))}
											</ul>
										)}
									</CardContent>
								</Card>

								{error ? (
									<p className="text-sm text-destructive">{error}</p>
								) : null}
								{feedback ? (
									<p className="text-sm text-muted-foreground">{feedback}</p>
								) : null}
							</div>
						)}
			</div>
		</div>
	);
}
