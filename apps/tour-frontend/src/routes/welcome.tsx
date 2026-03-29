import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useRef, useState } from "react";
import { Avatar, AvatarFallback, AvatarImage } from "#/components/ui/avatar";
import { Card, CardHeader, CardTitle } from "#/components/ui/card";
import { cn } from "#/lib/utils";
import {
	connectWelcomeSocket,
	type TourRosterPayload,
	type WelcomeUser,
} from "#/lib/welcome-data";

export const Route = createFileRoute("/welcome")({
	component: Welcome,
});

function Welcome() {
	const [roster, setRoster] = useState<TourRosterPayload | null>(null);
	const [arrivedEpcs, setArrivedEpcs] = useState<Set<string>>(() => new Set());
	const [legacyUsers, setLegacyUsers] = useState<WelcomeUser[]>([]);
	const rosterActiveRef = useRef(false);
	const seenLegacyEpc = useRef(new Set<string>());

	useEffect(() => {
		const disconnect = connectWelcomeSocket({
			onTourRoster: (payload) => {
				rosterActiveRef.current = true;
				setRoster(payload);
				setArrivedEpcs(new Set([payload.scanned_epc]));
				setLegacyUsers([]);
				seenLegacyEpc.current = new Set();
			},
			onWelcome: (user) => {
				if (rosterActiveRef.current) {
					setArrivedEpcs((prev) => new Set(prev).add(user.epc));
					return;
				}
				if (seenLegacyEpc.current.has(user.epc)) return;
				seenLegacyEpc.current.add(user.epc);
				setLegacyUsers((prev) => [...prev, user]);
			},
		});
		return disconnect;
	}, []);

	const hasRosterLayout = roster !== null;
	const showRosterGrid = roster !== null && roster.people.length > 0;
	const showLegacy = !hasRosterLayout && legacyUsers.length > 0;
	const showWaiting = !hasRosterLayout && !showLegacy;

	return (
		<main className="mx-auto flex min-h-[100dvh] w-full max-w-[min(92vw,1600px)] flex-col gap-10 px-8 py-12 md:gap-14 md:px-12 md:py-16 lg:gap-16 lg:px-16 lg:py-20">
			<div>
				<h1 className="text-balance text-4xl font-semibold tracking-tight text-foreground sm:text-5xl md:text-6xl lg:text-7xl lg:leading-[1.08]">
					Welcome to the RFID Lab
				</h1>
				{roster ? (
					<p className="mt-4 text-lg text-muted-foreground">
						<span className="font-medium text-foreground">
							{roster.company}
						</span>
						{roster.start_time ? (
							<>
								{" "}
								· Tour start{" "}
								{new Date(roster.start_time).toLocaleString("en-US", {
									timeZone: "America/Chicago",
								})}{" "}
								CST
							</>
						) : null}
					</p>
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

			{showRosterGrid && roster ? (
				<ul className="grid grid-cols-1 gap-4 sm:grid-cols-2 sm:gap-6 lg:gap-8 xl:grid-cols-4 xl:gap-10">
					{roster.people.map((user) => {
						const arrived = arrivedEpcs.has(user.epc);
						return (
							<li key={user.epc}>
								<Card
									className={cn(
										"py-6 transition-opacity duration-300 md:py-8",
										!arrived && "opacity-40",
									)}
								>
									<CardHeader className="gap-3 px-6 md:gap-4 md:px-8">
										<Avatar className="size-16 md:size-20">
											{user.photo_url ? (
												<AvatarImage
													src={user.photo_url}
													alt={`${user.first_name} ${user.last_name}`}
												/>
											) : null}
											<AvatarFallback className="text-lg md:text-xl">
												{user.first_name[0]}
												{user.last_name[0]}
											</AvatarFallback>
										</Avatar>
										<CardTitle className="text-2xl font-semibold md:text-3xl lg:text-4xl">
											{user.first_name} {user.last_name}
										</CardTitle>
										{user.email ? (
											<p className="text-sm text-muted-foreground">
												{user.email}
											</p>
										) : null}
										<p className="font-mono text-xs leading-snug sm:text-sm">
											<span className="text-muted-foreground">EPC </span>
											<span className="text-foreground">{user.epc}</span>
										</p>
									</CardHeader>
								</Card>
							</li>
						);
					})}
				</ul>
			) : null}

			{showLegacy ? (
				<ul className="grid grid-cols-1 gap-4 sm:grid-cols-2 sm:gap-6 lg:gap-8 xl:grid-cols-4 xl:gap-10">
					{legacyUsers.map((user) => (
						<li key={user.epc}>
							<Card className="py-6 md:py-8">
								<CardHeader className="gap-3 px-6 md:gap-4 md:px-8">
									<Avatar className="size-16 md:size-20">
										{user.photo_url ? (
											<AvatarImage
												src={user.photo_url}
												alt={`${user.first_name} ${user.last_name}`}
											/>
										) : null}
										<AvatarFallback className="text-lg md:text-xl">
											{user.first_name[0]}
											{user.last_name[0]}
										</AvatarFallback>
									</Avatar>
									<CardTitle className="text-2xl font-semibold md:text-3xl lg:text-4xl">
										{user.first_name} {user.last_name}
									</CardTitle>
									{user.email ? (
										<p className="text-sm text-muted-foreground">
											{user.email}
										</p>
									) : null}
									<p className="font-mono text-xs leading-snug sm:text-sm">
										<span className="text-muted-foreground">EPC </span>
										<span className="text-foreground">{user.epc}</span>
									</p>
								</CardHeader>
							</Card>
						</li>
					))}
				</ul>
			) : null}
		</main>
	);
}
