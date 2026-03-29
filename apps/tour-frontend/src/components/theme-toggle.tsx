import { useRouterState } from "@tanstack/react-router";
import { Monitor, Moon, Sun } from "lucide-react";
import { useCallback, useEffect, useState } from "react";
import { Button } from "#/components/ui/button";

export type ThemeMode = "light" | "dark" | "auto";

function applyTheme(mode: ThemeMode) {
	if (typeof document === "undefined") return;
	try {
		localStorage.setItem("theme", mode);
	} catch {
		/* ignore */
	}
	const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
	const resolved: "light" | "dark" =
		mode === "auto" ? (prefersDark ? "dark" : "light") : mode;
	const root = document.documentElement;
	root.classList.remove("light", "dark");
	root.classList.add(resolved);
	if (mode === "auto") {
		root.removeAttribute("data-theme");
	} else {
		root.setAttribute("data-theme", mode);
	}
	root.style.colorScheme = resolved;
}

const cycle: ThemeMode[] = ["auto", "light", "dark"];

function nextMode(current: ThemeMode): ThemeMode {
	const i = cycle.indexOf(current);
	return cycle[(i + 1) % cycle.length];
}

function readStoredMode(): ThemeMode {
	if (typeof window === "undefined") return "auto";
	try {
		const s = localStorage.getItem("theme");
		if (s === "light" || s === "dark" || s === "auto") return s;
	} catch {
		/* ignore */
	}
	return "auto";
}

function isWelcomeRoute(pathname: string): boolean {
	return pathname === "/welcome" || pathname.startsWith("/welcome/");
}

export function ThemeToggle() {
	const pathname = useRouterState({ select: (s) => s.location.pathname });
	const [mode, setMode] = useState<ThemeMode>("auto");
	const [fullscreen, setFullscreen] = useState(false);

	useEffect(() => {
		setMode(readStoredMode());
	}, []);

	useEffect(() => {
		const sync = () => setFullscreen(Boolean(document.fullscreenElement));
		sync();
		document.addEventListener("fullscreenchange", sync);
		return () => document.removeEventListener("fullscreenchange", sync);
	}, []);

	const hideOnWelcomeFullscreen =
		isWelcomeRoute(pathname) && fullscreen;

	useEffect(() => {
		if (mode !== "auto") return;
		const mq = window.matchMedia("(prefers-color-scheme: dark)");
		const onChange = () => applyTheme("auto");
		mq.addEventListener("change", onChange);
		return () => mq.removeEventListener("change", onChange);
	}, [mode]);

	const onClick = useCallback(() => {
		const next = nextMode(mode);
		setMode(next);
		applyTheme(next);
	}, [mode]);

	const label =
		mode === "auto"
			? "Theme: System"
			: mode === "light"
				? "Theme: Light"
				: "Theme: Dark";

	const Icon = mode === "auto" ? Monitor : mode === "light" ? Sun : Moon;

	if (hideOnWelcomeFullscreen) {
		return null;
	}

	return (
		<div className="pointer-events-none fixed bottom-3 right-3 z-40 md:bottom-4 md:right-4">
			<Button
				type="button"
				variant="ghost"
				size="icon-sm"
				className="pointer-events-auto text-muted-foreground opacity-70 shadow-none hover:bg-muted/60 hover:opacity-100"
				onClick={onClick}
				aria-label={`${label}. Click to cycle system, light, or dark.`}
				title={`${label} — click to cycle`}
			>
				<Icon className="size-4" aria-hidden />
			</Button>
		</div>
	);
}
