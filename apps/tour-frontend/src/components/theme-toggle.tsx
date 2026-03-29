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

export function ThemeToggle() {
	const [mode, setMode] = useState<ThemeMode>("auto");

	useEffect(() => {
		setMode(readStoredMode());
	}, []);

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

	return (
		<div className="fixed top-4 right-4 z-50">
			<Button
				type="button"
				variant="outline"
				size="sm"
				className="gap-2 bg-background/80 shadow-sm backdrop-blur-sm"
				onClick={onClick}
				aria-label={`${label}. Click to cycle system, light, or dark.`}
				title={`${label} — click to cycle`}
			>
				<Icon className="size-4" aria-hidden />
				<span className="hidden sm:inline">{label}</span>
			</Button>
		</div>
	);
}
