import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useRef, useState } from "react";
import { formatNameSingleLine } from "#/components/person-name";
import { Avatar, AvatarFallback, AvatarImage } from "#/components/ui/avatar";
import { Card, CardHeader, CardTitle } from "#/components/ui/card";
import { cn } from "#/lib/utils";
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
	const showWaiting = !hasRosterLayout && !showLegacy;

	const cardsSection =
		showRosterGrid || showLegacy ? (
			<div className="w-full px-4 pb-8 sm:px-5 sm:pb-10 md:px-6 lg:px-8">
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
												<span className="whitespace-nowrap">
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
											<span className="whitespace-nowrap">
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
		) : null;

	return (
		<main className="flex min-h-[100dvh] w-full flex-col gap-5 md:gap-6 lg:gap-7">
			<div className="mx-auto w-full max-w-7xl px-6 pb-2 pt-8 sm:px-8 sm:pt-10 md:px-10 md:pt-10 md:pb-3 lg:px-12 lg:pt-11">
				<div>
					<h1 className="text-balance text-4xl font-semibold tracking-tight text-foreground sm:text-5xl md:text-6xl lg:text-7xl lg:leading-[1.08]">
						Welcome to the RFID Lab
					</h1>
					{roster ? (
						<div className="mt-4 flex flex-wrap items-center gap-x-4 gap-y-2 text-lg text-muted-foreground">
							<div className="flex min-w-0 flex-wrap items-center gap-3">
								{roster.logo ? (
									<img
										src={roster.logo}
										alt=""
										className="h-10 w-auto max-h-12 max-w-xs shrink-0 object-contain object-left"
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

				{showWaiting ? (
					<p className="text-lg text-slate-400">
						Waiting for attendees to scan in...
					</p>
				) : null}

				{hasRosterLayout && roster && roster.people.length === 0 ? (
					<p className="text-lg text-muted-foreground">
						No participants assigned to this tour yet.
					</p>
				) : null}
			</div>

			{cardsSection}
		</main>
	);
}
