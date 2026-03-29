import { createFileRoute, Link } from "@tanstack/react-router";
import { RfidLabHeadingLine } from "#/components/rfid-lab-heading";
import { Button } from "#/components/ui/button";

export const Route = createFileRoute("/")({ component: Home });

function Home() {
	return (
		<main className="relative flex min-h-[100dvh] flex-col items-center justify-center gap-10 px-6 py-12 md:gap-14 md:px-16 lg:gap-16 lg:px-24">
			<Link
				to="/admin/people"
				className="fixed top-4 right-4 z-10 rounded-md px-2 py-1.5 text-xs font-medium uppercase tracking-wider text-muted-foreground/25 transition-colors hover:text-muted-foreground/65 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 md:top-5 md:right-5"
			>
				Admin
			</Link>
			<h1 className="w-full max-w-5xl text-center text-5xl font-medium tracking-tight text-foreground sm:text-6xl md:text-7xl lg:text-8xl lg:leading-[1.05]">
				<RfidLabHeadingLine />
			</h1>
			<div className="flex w-full max-w-3xl flex-nowrap items-center justify-center gap-3 overflow-x-auto pb-1 sm:gap-6 md:gap-8">
				<Button
					asChild
					size="lg"
					className="h-12 shrink-0 px-6 text-base sm:h-14 sm:min-w-44 sm:px-10 sm:text-lg md:h-16 md:min-w-48 md:text-xl"
				>
					<Link to="/welcome">Welcome</Link>
				</Button>
				<Button
					asChild
					size="lg"
					variant="outline"
					className="h-12 shrink-0 px-6 text-base sm:h-14 sm:min-w-44 sm:px-10 sm:text-lg md:h-16 md:min-w-48 md:text-xl"
				>
					<Link to="/lidar">LiDAR Demo</Link>
				</Button>
			</div>
		</main>
	);
}
