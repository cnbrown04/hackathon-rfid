import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useRef, useState } from "react";
import { Card, CardHeader, CardTitle } from "#/components/ui/card";
import { Avatar, AvatarImage, AvatarFallback } from "#/components/ui/avatar";
import { connectWelcomeSocket, type WelcomeUser } from "#/lib/welcome-data";

export const Route = createFileRoute("/welcome")({
	component: Welcome,
});

function Welcome() {
	const [users, setUsers] = useState<WelcomeUser[]>([]);
	const seenEpcs = useRef(new Set<string>());

	useEffect(() => {
		const disconnect = connectWelcomeSocket((user) => {
			if (seenEpcs.current.has(user.epc)) return;
			seenEpcs.current.add(user.epc);
			setUsers((prev) => [...prev, user]);
		});
		return disconnect;
	}, []);

	return (
		<main className="mx-auto flex min-h-[100dvh] w-full max-w-[min(92vw,1600px)] flex-col gap-10 px-8 py-12 md:gap-14 md:px-12 md:py-16 lg:gap-16 lg:px-16 lg:py-20">
			<h1 className="text-balance text-4xl font-semibold tracking-tight text-foreground sm:text-5xl md:text-6xl lg:text-7xl lg:leading-[1.08]">
				Welcome to the RFID Lab
			</h1>

			{users.length === 0 ? (
				<p className="text-lg text-slate-400">
					Waiting for attendees to scan in...
				</p>
			) : (
				<ul className="grid grid-cols-1 gap-4 sm:grid-cols-2 sm:gap-6 lg:gap-8 xl:grid-cols-4 xl:gap-10">
					{users.map((user) => (
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
			)}
		</main>
	);
}
