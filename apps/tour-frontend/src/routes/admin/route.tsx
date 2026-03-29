import {
	createFileRoute,
	Link,
	Outlet,
	useRouterState,
} from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { Button } from "#/components/ui/button";
import { Input } from "#/components/ui/input";
import { Label } from "#/components/ui/label";
import {
	clearAdminSecret,
	clearWelcomeScreens,
	getAdminSecret,
	login,
	setAdminSecret,
} from "#/lib/admin-api";
import {
	AlertDialog,
	AlertDialogAction,
	AlertDialogCancel,
	AlertDialogContent,
	AlertDialogDescription,
	AlertDialogFooter,
	AlertDialogHeader,
	AlertDialogTitle,
	AlertDialogTrigger,
} from "#/components/ui/alert-dialog";

export const Route = createFileRoute("/admin")({
	// Matches client-only admin data routes (Bearer token in sessionStorage).
	ssr: false,
	component: AdminLayout,
});

function NavLink({
	to,
	children,
}: {
	to: "/admin/people" | "/admin/tours" | "/admin/simulate" | "/admin/api";
	children: React.ReactNode;
}) {
	const pathname = useRouterState({ select: (s) => s.location.pathname });
	const active = pathname === to;
	return (
		<Link
			to={to}
			className={
				active
					? "text-foreground"
					: "text-muted-foreground transition-colors hover:text-foreground"
			}
		>
			{children}
		</Link>
	);
}

function AdminLayout() {
	const [ready, setReady] = useState(false);
	const [loggedIn, setLoggedIn] = useState(false);
	const [password, setPassword] = useState("");
	const [error, setError] = useState<string | null>(null);
	const [clearBusy, setClearBusy] = useState(false);
	const [clearFeedback, setClearFeedback] = useState<string | null>(null);

	useEffect(() => {
		setLoggedIn(!!getAdminSecret());
		setReady(true);
	}, []);

	async function onSubmit(e: React.FormEvent) {
		e.preventDefault();
		setError(null);
		const ok = await login(password);
		if (ok) {
			setAdminSecret(password);
			setLoggedIn(true);
			setPassword("");
		} else {
			setError("Wrong password");
		}
	}

	function logout() {
		clearAdminSecret();
		setLoggedIn(false);
	}

	async function onClearWelcomeScreens() {
		setClearFeedback(null);
		setClearBusy(true);
		try {
			await clearWelcomeScreens();
			setClearFeedback("Welcome screens cleared.");
		} catch (e) {
			setClearFeedback(
				e instanceof Error ? e.message : "Could not clear welcome screens.",
			);
		} finally {
			setClearBusy(false);
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
				<h1 className="text-2xl font-semibold tracking-tight">Admin</h1>
				<form onSubmit={onSubmit} className="flex flex-col gap-4">
					<div className="space-y-2">
						<Label htmlFor="admin-pw">Password</Label>
						<Input
							id="admin-pw"
							type="password"
							autoComplete="current-password"
							value={password}
							onChange={(e) => setPassword(e.target.value)}
						/>
					</div>
					{error ? <p className="text-sm text-destructive">{error}</p> : null}
					<Button type="submit">Sign in</Button>
				</form>
			</main>
		);
	}

	return (
		<div className="flex min-h-[100dvh] min-w-0 flex-col">
			<header className="border-border shrink-0 border-b bg-card/40">
				<div className="mx-auto flex w-full min-w-0 max-w-6xl flex-wrap items-center justify-between gap-x-6 gap-y-3 px-4 py-4 sm:px-6 lg:max-w-7xl lg:px-8">
					<nav className="flex min-w-0 flex-wrap items-center gap-x-6 gap-y-2 text-sm font-medium">
						<NavLink to="/admin/people">People</NavLink>
						<NavLink to="/admin/tours">Tours</NavLink>
						<NavLink to="/admin/simulate">Simulate</NavLink>
						<NavLink to="/admin/api">API</NavLink>
					</nav>
					<div className="flex shrink-0 flex-wrap items-center gap-2">
						<AlertDialog>
							<AlertDialogTrigger asChild>
								<Button
									type="button"
									variant="outline"
									size="sm"
									disabled={clearBusy}
								>
									Clear welcome screens
								</Button>
							</AlertDialogTrigger>
							<AlertDialogContent>
								<AlertDialogHeader>
									<AlertDialogTitle>Clear all welcome screens?</AlertDialogTitle>
									<AlertDialogDescription>
										This sends a reset to every browser on{" "}
										<code className="text-foreground">/welcome</code> (kiosk
										displays). Everyone will see the waiting state again.
									</AlertDialogDescription>
								</AlertDialogHeader>
								<AlertDialogFooter>
									<AlertDialogCancel>Cancel</AlertDialogCancel>
									<AlertDialogAction
										onClick={() => {
											void onClearWelcomeScreens();
										}}
									>
										Clear everyone
									</AlertDialogAction>
								</AlertDialogFooter>
							</AlertDialogContent>
						</AlertDialog>
						{clearFeedback ? (
							<span
								className={
									clearFeedback.startsWith("Welcome")
										? "text-sm text-muted-foreground"
										: "text-sm text-destructive"
								}
							>
								{clearFeedback}
							</span>
						) : null}
						<Button
							type="button"
							variant="outline"
							size="sm"
							onClick={logout}
						>
							Log out
						</Button>
					</div>
				</div>
			</header>
			<div className="mx-auto flex w-full min-w-0 max-w-6xl flex-1 flex-col px-4 py-8 sm:px-6 sm:py-10 lg:max-w-7xl lg:px-8">
				<Outlet />
			</div>
		</div>
	);
}
