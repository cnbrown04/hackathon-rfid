import { createFileRoute } from "@tanstack/react-router";
import { AnimatePresence, motion, useReducedMotion } from "framer-motion";
import { Check, Radio, Sparkles } from "lucide-react";
import { useEffect, useState } from "react";
import { Badge } from "#/components/ui/badge";
import { Button } from "#/components/ui/button";
import { Card, CardContent, CardHeader } from "#/components/ui/card";
import {
	ANTENNA_FLOW_TIMING,
	type AntennaReadEvent,
	TEST_ANTENNA_READS,
} from "#/lib/antenna-flow-data";

export const Route = createFileRoute("/antenna")({
	component: AntennaFlowRoute,
});

function burstConfetti(reducedMotion: boolean) {
	if (reducedMotion || typeof window === "undefined") return;
	void import("canvas-confetti").then(({ default: c }) => {
		c({
			particleCount: 110,
			spread: 78,
			startVelocity: 38,
			origin: { y: 0.55 },
			scalar: 1.1,
		});
		window.setTimeout(() => {
			c({
				particleCount: 70,
				angle: 55,
				spread: 50,
				origin: { x: 0.15, y: 0.6 },
				startVelocity: 28,
			});
		}, 200);
		window.setTimeout(() => {
			c({
				particleCount: 70,
				angle: 125,
				spread: 50,
				origin: { x: 0.85, y: 0.6 },
				startVelocity: 28,
			});
		}, 350);
	});
}

function AntennaFlowRoute() {
	const [sessionKey, setSessionKey] = useState(0);
	return (
		<AntennaFlowSession
			key={sessionKey}
			onReplay={() => setSessionKey((k) => k + 1)}
		/>
	);
}

function AntennaFlowSession({ onReplay }: { onReplay: () => void }) {
	const reducedMotion = useReducedMotion();
	const events = TEST_ANTENNA_READS;
	const [activeIndex, setActiveIndex] = useState(-1);

	useEffect(() => {
		const reads = TEST_ANTENNA_READS;
		let cancelled = false;
		const timeouts: number[] = [];

		const schedule = (ms: number, fn: () => void) => {
			timeouts.push(
				window.setTimeout(() => {
					if (!cancelled) fn();
				}, ms),
			);
		};

		const advance = (i: number) => {
			if (cancelled) return;
			setActiveIndex(i);
			if (i < reads.length - 1) {
				schedule(ANTENNA_FLOW_TIMING.stepHoldMs, () => advance(i + 1));
			} else if (i === reads.length - 1) {
				schedule(ANTENNA_FLOW_TIMING.stepHoldMs, () => {
					if (!cancelled) setActiveIndex(reads.length);
				});
			}
		};

		schedule(ANTENNA_FLOW_TIMING.initialDelayMs, () => advance(0));

		return () => {
			cancelled = true;
			for (const id of timeouts) window.clearTimeout(id);
		};
	}, []);

	useEffect(() => {
		const len = TEST_ANTENNA_READS.length;
		if (activeIndex >= 0 && activeIndex < len) {
			burstConfetti(!!reducedMotion);
		}
		if (activeIndex === len) {
			burstConfetti(!!reducedMotion);
			if (!reducedMotion) {
				window.setTimeout(() => burstConfetti(!!reducedMotion), 400);
			}
		}
	}, [activeIndex, reducedMotion]);

	const currentEvent: AntennaReadEvent | null =
		activeIndex >= 0 && activeIndex < events.length
			? events[activeIndex]
			: null;

	return (
		<main className="relative isolate flex min-h-[100dvh] flex-col overflow-hidden bg-background px-6 py-10 md:px-10 md:py-12">
			<BackgroundGlow reducedMotion={!!reducedMotion} />

			<header className="relative z-10 mx-auto w-full max-w-4xl">
				<motion.div
					className="mb-8 flex items-center gap-2 text-muted-foreground"
					initial={reducedMotion ? false : { opacity: 0, y: -8 }}
					animate={{ opacity: 1, y: 0 }}
					transition={{ duration: reducedMotion ? 0 : 0.45 }}
				>
					<Radio className="size-5 shrink-0 text-primary" aria-hidden />
					<p className="text-sm font-medium tracking-wide uppercase md:text-base">
						Live antenna reads
					</p>
				</motion.div>

				<Stepper
					events={events}
					activeIndex={activeIndex}
					reducedMotion={!!reducedMotion}
				/>
			</header>

			<section className="relative z-10 mx-auto flex w-full max-w-3xl flex-1 flex-col items-center justify-center py-8">
				<AnimatePresence mode="wait">
					{activeIndex < 0 && (
						<IdlePanel key="idle" reducedMotion={!!reducedMotion} />
					)}
					{currentEvent && (
						<EventPanel
							key={currentEvent.antennaId + activeIndex}
							event={currentEvent}
							stepNumber={activeIndex + 1}
							stepTotal={events.length}
							reducedMotion={!!reducedMotion}
						/>
					)}
					{activeIndex === events.length && (
						<DonePanel
							key="done"
							events={events}
							reducedMotion={!!reducedMotion}
							onReplay={onReplay}
						/>
					)}
				</AnimatePresence>
			</section>

			<p className="relative z-10 mx-auto max-w-xl text-center text-xs text-muted-foreground md:text-sm">
				Test data auto-advances. Wire this timeline to your backend when reads
				arrive.
			</p>
		</main>
	);
}

function BackgroundGlow({ reducedMotion }: { reducedMotion: boolean }) {
	return (
		<div className="pointer-events-none absolute inset-0 overflow-hidden">
			<motion.div
				className="absolute -left-1/4 top-0 h-[50vmin] w-[50vmin] rounded-full bg-primary/15 blur-3xl"
				animate={
					reducedMotion
						? undefined
						: {
								x: [0, 30, 0],
								y: [0, 20, 0],
								scale: [1, 1.08, 1],
							}
				}
				transition={{
					duration: 14,
					repeat: Number.POSITIVE_INFINITY,
					ease: "easeInOut",
				}}
			/>
			<motion.div
				className="absolute -right-1/4 bottom-0 h-[45vmin] w-[45vmin] rounded-full bg-chart-2/25 blur-3xl"
				animate={
					reducedMotion
						? undefined
						: {
								x: [0, -24, 0],
								y: [0, -16, 0],
							}
				}
				transition={{
					duration: 11,
					repeat: Number.POSITIVE_INFINITY,
					ease: "easeInOut",
				}}
			/>
		</div>
	);
}

function Stepper({
	events,
	activeIndex,
	reducedMotion,
}: {
	events: AntennaReadEvent[];
	activeIndex: number;
	reducedMotion: boolean;
}) {
	return (
		<ol className="flex flex-wrap items-center gap-2 md:gap-3">
			{events.map((ev, i) => {
				const done = activeIndex > i;
				const current = activeIndex === i;

				return (
					<li key={ev.antennaId} className="flex items-center gap-2 md:gap-3">
						{i > 0 && (
							<motion.div
								className="hidden h-px w-6 bg-border sm:block md:w-10"
								initial={false}
								animate={{
									backgroundColor:
										done || current ? "var(--primary)" : undefined,
									opacity: done || current ? 0.45 : 0.25,
									scaleX: done ? 1 : 0.6,
								}}
								transition={{ duration: reducedMotion ? 0 : 0.35 }}
							/>
						)}
						<motion.div
							className="flex items-center gap-2 rounded-full border px-3 py-1.5 md:px-4 md:py-2"
							initial={false}
							animate={{
								borderColor: current
									? "var(--ring)"
									: done
										? "color-mix(in oklab, var(--primary) 35%, var(--border))"
										: "var(--border)",
								backgroundColor: current
									? "color-mix(in oklab, var(--primary) 12%, transparent)"
									: done
										? "color-mix(in oklab, var(--primary) 6%, transparent)"
										: "transparent",
								scale: current && !reducedMotion ? 1.04 : 1,
							}}
							transition={{ type: "spring", stiffness: 420, damping: 28 }}
						>
							<span className="flex size-7 items-center justify-center rounded-full bg-muted text-xs font-semibold text-muted-foreground md:size-8 md:text-sm">
								{done ? (
									<Check className="size-4 text-primary" aria-hidden />
								) : (
									i + 1
								)}
							</span>
							<span className="max-w-[8rem] truncate text-xs font-medium text-foreground md:max-w-[10rem] md:text-sm">
								{ev.antennaLabel}
							</span>
						</motion.div>
					</li>
				);
			})}
		</ol>
	);
}

function IdlePanel({ reducedMotion }: { reducedMotion: boolean }) {
	return (
		<motion.div
			role="status"
			aria-live="polite"
			className="flex flex-col items-center gap-6 text-center"
			initial={reducedMotion ? false : { opacity: 0, scale: 0.96 }}
			animate={{ opacity: 1, scale: 1 }}
			exit={reducedMotion ? undefined : { opacity: 0, scale: 1.03 }}
			transition={{ duration: reducedMotion ? 0 : 0.4 }}
		>
			<motion.div
				className="relative flex size-28 items-center justify-center rounded-full border-2 border-dashed border-primary/40 bg-muted/40 md:size-36"
				animate={
					reducedMotion
						? undefined
						: { rotate: [0, 2, -2, 0], scale: [1, 1.03, 1] }
				}
				transition={{
					duration: 3.2,
					repeat: Number.POSITIVE_INFINITY,
					ease: "easeInOut",
				}}
			>
				<Radio className="size-12 text-primary/80 md:size-14" aria-hidden />
				{!reducedMotion && (
					<motion.span
						className="absolute inset-0 rounded-full border-2 border-primary/30"
						animate={{ scale: [1, 1.15, 1], opacity: [0.5, 0, 0.5] }}
						transition={{ duration: 2.4, repeat: Number.POSITIVE_INFINITY }}
					/>
				)}
			</motion.div>
			<div>
				<p className="text-xl font-semibold text-foreground md:text-2xl">
					Listening for antennas…
				</p>
				<p className="mt-2 text-sm text-muted-foreground md:text-base">
					Tag reads will appear as each step unlocks.
				</p>
			</div>
		</motion.div>
	);
}

function EventPanel({
	event,
	stepNumber,
	stepTotal,
	reducedMotion,
}: {
	event: AntennaReadEvent;
	stepNumber: number;
	stepTotal: number;
	reducedMotion: boolean;
}) {
	const lineVariants = {
		hidden: { opacity: 0, y: 12 },
		show: (n: number) => ({
			opacity: 1,
			y: 0,
			transition: {
				delay: reducedMotion ? 0 : 0.08 * n,
				duration: reducedMotion ? 0 : 0.38,
				ease: [0.22, 1, 0.36, 1] as const,
			},
		}),
	};

	return (
		<motion.div
			role="status"
			aria-live="polite"
			aria-atomic="true"
			className="w-full"
			initial={
				reducedMotion ? false : { opacity: 0, x: 56, filter: "blur(8px)" }
			}
			animate={{ opacity: 1, x: 0, filter: "blur(0px)" }}
			exit={
				reducedMotion ? undefined : { opacity: 0, x: -48, filter: "blur(6px)" }
			}
			transition={{
				duration: reducedMotion ? 0 : 0.5,
				ease: [0.22, 1, 0.36, 1],
			}}
		>
			<Card className="overflow-hidden border-2 border-primary/20 shadow-lg ring-2 ring-primary/10">
				<CardHeader className="flex flex-row flex-wrap items-center justify-between gap-3 border-b bg-muted/30 px-6 py-4 md:px-8 md:py-5">
					<div className="flex flex-wrap items-center gap-2">
						<Badge variant="secondary" className="font-mono text-xs md:text-sm">
							{event.antennaId}
						</Badge>
						<span className="text-sm font-medium text-muted-foreground md:text-base">
							Step {stepNumber} / {stepTotal}
						</span>
					</div>
					<motion.div
						animate={reducedMotion ? undefined : { rotate: [0, 12, -8, 0] }}
						transition={{ duration: 2.2, repeat: Number.POSITIVE_INFINITY }}
					>
						<Sparkles className="size-6 text-primary md:size-7" aria-hidden />
					</motion.div>
				</CardHeader>
				<CardContent className="space-y-6 px-6 py-8 md:px-10 md:py-10">
					<motion.p
						custom={0}
						variants={lineVariants}
						initial="hidden"
						animate="show"
						className="text-sm font-medium uppercase tracking-wider text-muted-foreground md:text-base"
					>
						{event.antennaLabel}
					</motion.p>
					<motion.p
						custom={1}
						variants={lineVariants}
						initial="hidden"
						animate="show"
						className="text-balance text-4xl font-bold tracking-tight text-foreground md:text-5xl lg:text-6xl"
					>
						{event.userName}
					</motion.p>
					<motion.p
						custom={2}
						variants={lineVariants}
						initial="hidden"
						animate="show"
						className="font-mono text-lg text-muted-foreground md:text-xl lg:text-2xl"
					>
						<span className="text-muted-foreground">EPC </span>
						<span className="text-foreground">{event.epc}</span>
					</motion.p>
				</CardContent>
			</Card>
		</motion.div>
	);
}

function DonePanel({
	events,
	reducedMotion,
	onReplay,
}: {
	events: AntennaReadEvent[];
	reducedMotion: boolean;
	onReplay: () => void;
}) {
	return (
		<motion.div
			className="w-full space-y-8 text-center"
			initial={reducedMotion ? false : { opacity: 0, y: 24 }}
			animate={{ opacity: 1, y: 0 }}
			exit={reducedMotion ? undefined : { opacity: 0, y: -16 }}
			transition={{ duration: reducedMotion ? 0 : 0.45 }}
		>
			<motion.div
				className="mx-auto flex size-20 items-center justify-center rounded-full bg-primary/15 md:size-24"
				initial={reducedMotion ? false : { scale: 0 }}
				animate={{ scale: 1 }}
				transition={{ type: "spring", stiffness: 320, damping: 18 }}
			>
				<Sparkles className="size-10 text-primary md:size-12" aria-hidden />
			</motion.div>
			<div>
				<h2 className="text-3xl font-bold text-foreground md:text-4xl">
					All antennas logged
				</h2>
				<p className="mt-2 text-muted-foreground md:text-lg">
					{events.length} reads recorded on this run.
				</p>
			</div>
			<ul className="mx-auto max-w-lg space-y-2 text-left text-sm text-muted-foreground md:text-base">
				{events.map((ev) => (
					<li
						key={ev.antennaId}
						className="flex flex-col gap-0.5 rounded-md border border-border/80 bg-card/60 px-4 py-3 sm:flex-row sm:items-center sm:justify-between"
					>
						<span className="font-medium text-foreground">{ev.userName}</span>
						<span className="font-mono text-xs text-muted-foreground sm:text-sm">
							{ev.antennaLabel} · {ev.epc.slice(-6)}
						</span>
					</li>
				))}
			</ul>
			<Button
				type="button"
				size="lg"
				variant="outline"
				className="text-base"
				onClick={onReplay}
			>
				Run again
			</Button>
		</motion.div>
	);
}
