import { createFileRoute } from "@tanstack/react-router";
import { Card, CardHeader, CardTitle } from "#/components/ui/card";
import { fetchWelcomeLabData } from "#/lib/welcome-data";

export const Route = createFileRoute("/welcome")({
	loader: () => fetchWelcomeLabData(),
	component: Welcome,
});

function Welcome() {
	const { companyName, users } = Route.useLoaderData();

	return (
		<main className="mx-auto flex min-h-[100dvh] w-full max-w-[min(92vw,1600px)] flex-col gap-10 px-8 py-12 md:gap-14 md:px-12 md:py-16 lg:gap-16 lg:px-16 lg:py-20">
			<h1 className="text-balance text-4xl font-semibold tracking-tight text-foreground sm:text-5xl md:text-6xl lg:text-7xl lg:leading-[1.08]">
				Hello {companyName}. Welcome to the RFID lab.
			</h1>

			<ul className="grid grid-cols-1 gap-4 sm:grid-cols-2 sm:gap-6 lg:gap-8 xl:grid-cols-4 xl:gap-10">
				{users.map((user) => (
					<li key={user.id}>
						<Card className="py-6 md:py-8">
							<CardHeader className="gap-2 px-6 md:gap-3 md:px-8">
								<CardTitle className="text-2xl font-semibold md:text-3xl lg:text-4xl">
									{user.name}
								</CardTitle>
								<p className="font-mono text-xs leading-snug sm:text-sm">
									<span className="text-muted-foreground">EPC </span>
									<span className="text-foreground">{user.epc}</span>
								</p>
							</CardHeader>
						</Card>
					</li>
				))}
			</ul>
		</main>
	);
}
