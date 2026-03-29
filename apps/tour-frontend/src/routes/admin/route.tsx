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
	getAdminSecret,
	login,
	setAdminSecret,
} from "#/lib/admin-api";

export const Route = createFileRoute("/admin")({
	// Matches client-only admin data routes (Bearer token in sessionStorage).
	ssr: false,
	component: AdminLayout,
});

function NavLink({
	to,
	children,
}: {
	to: "/admin/people" | "/admin/tours";
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

	if (!ready) {
		return (
			<div className="flex min-h-[100dvh] items-center justify-center text-muted-foreground">
				Loading…
			</div>
		);
	}

	if (!loggedIn) {
		return (
			<main className="mx-auto flex min-h-[100dvh] max-w-md flex-col justify-center gap-8 px-6 py-12">
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
		<div className="min-h-[100dvh]">
			<header className="border-border border-b bg-card/40">
				<div className="mx-auto flex w-full max-w-screen-2xl flex-wrap items-center justify-between gap-4 px-6 py-4 sm:px-8">
					<nav className="flex flex-wrap items-center gap-6 text-sm font-medium">
						<NavLink to="/admin/people">People</NavLink>
						<NavLink to="/admin/tours">Tours</NavLink>
					</nav>
					<Button type="button" variant="outline" size="sm" onClick={logout}>
						Log out
					</Button>
				</div>
			</header>
			<div className="mx-auto w-full max-w-screen-2xl px-6 py-10 sm:px-8">
				<Outlet />
			</div>
		</div>
	);
}
