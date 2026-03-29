import { createFileRoute } from "@tanstack/react-router";
import { useEffect, useMemo, useState } from "react";
import { cn } from "#/lib/utils";

const METHOD_ORDER = [
	"get",
	"post",
	"put",
	"delete",
	"patch",
	"options",
	"head",
] as const;

type HttpMethod = (typeof METHOD_ORDER)[number];

type OpObject = {
	tags?: string[];
	summary?: string;
	description?: string;
	security?: unknown[];
	operationId?: string;
};

type PathsObject = Record<string, Partial<Record<HttpMethod, OpObject>>>;

type OpenApiDoc = {
	paths?: PathsObject;
	info?: { title?: string; version?: string; description?: string };
};

function apiBaseUrl(): string {
	if (
		typeof import.meta.env.VITE_API_URL === "string" &&
		import.meta.env.VITE_API_URL.length > 0
	) {
		return import.meta.env.VITE_API_URL;
	}
	return "http://localhost:3002";
}

function needsBearer(op: OpObject): boolean {
	const s = op.security;
	if (!s || s.length === 0) return false;
	return s.some(
		(item) =>
			item &&
			typeof item === "object" &&
			"AdminBearer" in (item as Record<string, unknown>),
	);
}

function buildGroups(doc: OpenApiDoc) {
	const paths = doc.paths ?? {};
	const byTag = new Map<
		string,
		{ method: HttpMethod; path: string; op: OpObject }[]
	>();

	for (const [p, pathItem] of Object.entries(paths)) {
		for (const method of METHOD_ORDER) {
			const op = pathItem[method];
			if (!op) continue;
			const tag = op.tags?.[0] ?? "Other";
			if (!byTag.has(tag)) byTag.set(tag, []);
			const bucket = byTag.get(tag);
			if (bucket) bucket.push({ method, path: p, op });
		}
	}

	for (const [, list] of byTag) {
		list.sort(
			(a, b) =>
				a.path.localeCompare(b.path) || a.method.localeCompare(b.method),
		);
	}

	const tagOrder = ["Public", "Admin", "Events", "Other"];
	const groups = tagOrder
		.filter((t) => byTag.has(t))
		.map((tag) => ({ tag, routes: byTag.get(tag) ?? [] }));

	for (const t of byTag.keys()) {
		if (!tagOrder.includes(t)) {
			groups.push({ tag: t, routes: byTag.get(t) ?? [] });
		}
	}

	return { groups, info: doc.info };
}

export const Route = createFileRoute("/admin/api")({
	ssr: false,
	component: AdminApiDocs,
});

function AdminApiDocs() {
	const apiBase = apiBaseUrl();

	const [doc, setDoc] = useState<OpenApiDoc | null>(null);
	const [loadError, setLoadError] = useState<string | null>(null);

	useEffect(() => {
		let cancelled = false;
		setLoadError(null);
		setDoc(null);
		const base = apiBaseUrl().replace(/\/$/, "");
		fetch(`${base}/openapi.json`, {
			headers: { Accept: "application/json" },
		})
			.then(async (r) => {
				if (!r.ok) {
					throw new Error(r.statusText || `HTTP ${r.status}`);
				}
				return r.json() as Promise<OpenApiDoc>;
			})
			.then((data) => {
				if (!cancelled) setDoc(data);
			})
			.catch((e: unknown) => {
				if (!cancelled) {
					setLoadError(
						e instanceof Error ? e.message : "Failed to load OpenAPI spec",
					);
				}
			});
		return () => {
			cancelled = true;
		};
	}, []);

	const { groups, info } = useMemo(
		() => (doc ? buildGroups(doc) : { groups: [], info: undefined }),
		[doc],
	);

	return (
		<div className="flex min-w-0 flex-col gap-8">
			<div>
				<h1 className="text-2xl font-semibold tracking-tight">HTTP API</h1>
				<p className="mt-2 max-w-prose text-sm text-muted-foreground">
					Routes served by the RFID Lab Node server (
					{info?.title ?? "RFID Lab HTTP API"}{" "}
					{info?.version ? `v${info.version}` : null}). Base URL for this
					environment:{" "}
					<code className="text-xs text-foreground">{apiBase}</code>
				</p>
				<p className="mt-2 text-sm text-muted-foreground">
					Spec is loaded at runtime from{" "}
					<code className="text-xs">GET /openapi.json</code> (same content as{" "}
					<code className="text-xs">apps/server/openapi.yaml</code>). Admin JSON
					routes expect{" "}
					<code className="text-xs">
						Authorization: Bearer &lt;password&gt;
					</code>{" "}
					unless noted otherwise.
				</p>
			</div>

			{loadError ? (
				<p className="text-sm text-destructive">
					Could not load OpenAPI spec from the API ({loadError}). Is the server
					running at {apiBase}?
				</p>
			) : null}

			{!doc && !loadError ? (
				<p className="text-sm text-muted-foreground">Loading…</p>
			) : null}

			{doc ? (
				<div className="flex flex-col gap-10">
					{groups.map(({ tag, routes }) => (
						<section key={tag} className="min-w-0">
							<h2 className="mb-4 border-b border-border pb-2 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
								{tag}
							</h2>
							<ul className="flex flex-col gap-3">
								{routes.map(({ method, path: routePath, op }) => (
									<li
										key={`${method}:${routePath}`}
										className="rounded-none border border-border bg-card/20 px-4 py-3 sm:px-5"
									>
										<div className="flex flex-wrap items-baseline gap-x-3 gap-y-1">
											<span
												className={cn(
													"font-mono text-[11px] font-semibold uppercase tracking-wide",
													method === "get" && "text-sky-600 dark:text-sky-400",
													method === "post" &&
														"text-emerald-600 dark:text-emerald-400",
													method === "put" &&
														"text-amber-600 dark:text-amber-400",
													method === "delete" &&
														"text-rose-600 dark:text-rose-400",
												)}
											>
												{method}
											</span>
											<code className="min-w-0 flex-1 break-all font-mono text-sm text-foreground">
												{routePath}
											</code>
											{needsBearer(op) ? (
												<span className="shrink-0 rounded-none border border-border px-1.5 py-0.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
													Bearer
												</span>
											) : null}
										</div>
										{op.summary ? (
											<p className="mt-2 text-sm text-foreground">
												{op.summary}
											</p>
										) : null}
										{op.description ? (
											<p className="mt-1 whitespace-pre-wrap text-xs leading-relaxed text-muted-foreground">
												{op.description}
											</p>
										) : null}
										{op.operationId ? (
											<p className="mt-2 font-mono text-[10px] text-muted-foreground/80">
												{op.operationId}
											</p>
										) : null}
									</li>
								))}
							</ul>
						</section>
					))}
				</div>
			) : null}
		</div>
	);
}
