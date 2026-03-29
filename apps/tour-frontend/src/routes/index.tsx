import { createFileRoute, Link } from "@tanstack/react-router";
import { Button } from "#/components/ui/button";

export const Route = createFileRoute("/")({ component: Home });

function Home() {
	return (
		<main className="flex min-h-[100dvh] flex-col items-center justify-center gap-10 px-8 py-12 md:gap-14 md:px-16 lg:gap-16 lg:px-24">
			<h1 className="max-w-[90vw] text-center text-5xl font-medium tracking-tight text-foreground sm:text-6xl md:text-7xl lg:text-8xl lg:leading-[1.05]">
				Welcome to the RFID lab.
			</h1>
			<div className="flex flex-wrap items-center justify-center gap-4 md:gap-6">
				<Button
					asChild
					size="lg"
					className="h-14 min-w-[12rem] px-10 text-lg md:h-16 md:min-w-[14rem] md:px-12 md:text-xl"
				>
					<Link to="/welcome">Open welcome</Link>
				</Button>
				<Button
					asChild
					size="lg"
					variant="outline"
					className="h-14 min-w-[12rem] px-10 text-lg md:h-16 md:min-w-[14rem] md:px-12 md:text-xl"
				>
					<Link to="/antenna">Antenna flow</Link>
				</Button>
				<Button
					asChild
					size="lg"
					variant="outline"
					className="h-14 min-w-[12rem] px-10 text-lg md:h-16 md:min-w-[14rem] md:px-12 md:text-xl"
				>
					<Link to="/lidar">LiDAR shelf</Link>
				</Button>
				<Button
					asChild
					size="lg"
					variant="ghost"
					className="h-14 min-w-[12rem] px-10 text-lg text-muted-foreground md:h-16 md:min-w-[14rem] md:px-12 md:text-xl"
				>
					<Link to="/admin/people">Admin</Link>
				</Button>
			</div>
		</main>
	);
}
