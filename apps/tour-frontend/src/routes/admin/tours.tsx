import { createFileRoute } from "@tanstack/react-router";
import { useCallback, useEffect, useState } from "react";
import {
	AlertDialog,
	AlertDialogCancel,
	AlertDialogContent,
	AlertDialogDescription,
	AlertDialogFooter,
	AlertDialogHeader,
	AlertDialogTitle,
} from "#/components/ui/alert-dialog";
import { Button } from "#/components/ui/button";
import {
	Dialog,
	DialogContent,
	DialogFooter,
	DialogHeader,
	DialogTitle,
} from "#/components/ui/dialog";
import { Input } from "#/components/ui/input";
import { Label } from "#/components/ui/label";
import {
	Table,
	TableBody,
	TableCell,
	TableHead,
	TableHeader,
	TableRow,
} from "#/components/ui/table";
import {
	createTour,
	deleteTour,
	fetchPeople,
	fetchTours,
	type PersonRow,
	type TourRow,
	updateTour,
} from "#/lib/admin-api";

export const Route = createFileRoute("/admin/tours")({
	component: ManageTours,
});

function toDatetimeLocalValue(iso: string | null | undefined): string {
	if (!iso) return "";
	const d = new Date(iso);
	if (Number.isNaN(d.getTime())) return "";
	const pad = (n: number) => String(n).padStart(2, "0");
	return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function formatStartCst(iso: string | null | undefined): string {
	if (!iso) return "—";
	const d = new Date(iso);
	if (Number.isNaN(d.getTime())) return "—";
	return d.toLocaleString("en-US", { timeZone: "America/Chicago" });
}

function formatAmbassador(p: PersonRow | undefined): string {
	if (!p) return "—";
	return `${p.first_name} ${p.last_name} (#${p.id})`;
}

function ManageTours() {
	const [tours, setTours] = useState<TourRow[]>([]);
	const [people, setPeople] = useState<PersonRow[]>([]);
	const [loadError, setLoadError] = useState<string | null>(null);
	const [form, setForm] = useState({
		company: "",
		ambassador_id: "",
		start_time: "",
	});
	const [editOpen, setEditOpen] = useState(false);
	const [editing, setEditing] = useState<TourRow | null>(null);
	const [editForm, setEditForm] = useState({
		company: "",
		ambassador_id: "",
		start_time: "",
	});
	const [deleteTarget, setDeleteTarget] = useState<TourRow | null>(null);

	const refresh = useCallback(async () => {
		setLoadError(null);
		try {
			const [t, p] = await Promise.all([fetchTours(), fetchPeople()]);
			setTours(t);
			setPeople(p);
		} catch (e) {
			setLoadError(e instanceof Error ? e.message : "Failed to load");
		}
	}, []);

	useEffect(() => {
		void refresh();
	}, [refresh]);

	const ambassadors = people.filter((p) => p.role === "ambassador");

	/** Dropdown options: ambassadors only; when editing, include current assignee if they are not in that list. */
	function ambassadorSelectPeople(
		currentAmbassadorId: number | null | undefined,
	) {
		if (currentAmbassadorId == null) return ambassadors;
		const current = people.find((p) => p.id === currentAmbassadorId);
		if (current && !ambassadors.some((a) => a.id === current.id)) {
			return [current, ...ambassadors];
		}
		return ambassadors;
	}

	function personById(id: number | null) {
		if (id == null) return undefined;
		return people.find((x) => x.id === id);
	}

	async function onCreate(e: React.FormEvent) {
		e.preventDefault();
		if (!form.company.trim()) return;
		try {
			await createTour({
				company: form.company.trim(),
				ambassador_id: form.ambassador_id
					? Number.parseInt(form.ambassador_id, 10)
					: null,
				start_time: form.start_time
					? new Date(form.start_time).toISOString()
					: null,
			});
			setForm({ company: "", ambassador_id: "", start_time: "" });
			await refresh();
		} catch (err) {
			window.alert(err instanceof Error ? err.message : "Error");
		}
	}

	function openEdit(row: TourRow) {
		setEditing(row);
		setEditForm({
			company: row.company,
			ambassador_id: row.ambassador_id != null ? String(row.ambassador_id) : "",
			start_time: toDatetimeLocalValue(row.start_time),
		});
		setEditOpen(true);
	}

	async function onSaveEdit() {
		if (!editing) return;
		if (!editForm.company.trim()) return;
		try {
			await updateTour(editing.id, {
				company: editForm.company.trim(),
				ambassador_id: editForm.ambassador_id
					? Number.parseInt(editForm.ambassador_id, 10)
					: null,
				start_time: editForm.start_time
					? new Date(editForm.start_time).toISOString()
					: null,
			});
			setEditOpen(false);
			setEditing(null);
			await refresh();
		} catch (err) {
			window.alert(err instanceof Error ? err.message : "Error");
		}
	}

	async function confirmDeleteTour() {
		if (!deleteTarget) return;
		try {
			await deleteTour(deleteTarget.id);
			setDeleteTarget(null);
			await refresh();
		} catch (err) {
			window.alert(err instanceof Error ? err.message : "Error");
		}
	}

	return (
		<div className="flex flex-col gap-10">
			<div>
				<h1 className="text-xl font-semibold tracking-tight">Tours</h1>
				<p className="mt-1 text-sm text-muted-foreground">
					Optional ambassador — only people with the ambassador role appear here
				</p>
			</div>

			<section className="border border-border bg-card/30 p-6">
				<h2 className="mb-4 text-sm font-medium">Add tour</h2>
				<form
					onSubmit={onCreate}
					className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3"
				>
					<div className="space-y-2">
						<Label htmlFor="tour-co">Company</Label>
						<Input
							id="tour-co"
							value={form.company}
							onChange={(e) =>
								setForm((f) => ({ ...f, company: e.target.value }))
							}
							required
						/>
					</div>
					<div className="space-y-2">
						<Label htmlFor="tour-am">Ambassador</Label>
						<select
							id="tour-am"
							className="border-input bg-background h-9 w-full border px-3 text-sm"
							value={form.ambassador_id}
							onChange={(e) =>
								setForm((f) => ({ ...f, ambassador_id: e.target.value }))
							}
						>
							<option value="">None</option>
							{ambassadors.map((p) => (
								<option key={p.id} value={p.id}>
									{p.first_name} {p.last_name} (#{p.id})
								</option>
							))}
						</select>
					</div>
					<div className="space-y-2">
						<Label htmlFor="tour-st">Start time</Label>
						<Input
							id="tour-st"
							type="datetime-local"
							value={form.start_time}
							onChange={(e) =>
								setForm((f) => ({ ...f, start_time: e.target.value }))
							}
						/>
						<p className="text-muted-foreground text-[11px]">
							Optional. Used to pick this tour for ambassador scans (nearest
							time to now). Welcome page shows this in CST.
						</p>
					</div>
					<div className="sm:col-span-2 lg:col-span-3">
						<Button type="submit">Add</Button>
					</div>
				</form>
			</section>

			<section>
				<h2 className="mb-4 text-sm font-medium">All tours</h2>
				{loadError ? (
					<p className="text-sm text-destructive">{loadError}</p>
				) : (
					<div className="border border-border">
						<Table>
							<TableHeader>
								<TableRow>
									<TableHead>Company</TableHead>
									<TableHead>Start (CST)</TableHead>
									<TableHead>Ambassador</TableHead>
									<TableHead className="font-mono text-[11px]">ID</TableHead>
									<TableHead className="text-right">Actions</TableHead>
								</TableRow>
							</TableHeader>
							<TableBody>
								{tours.map((r) => (
									<TableRow key={r.id}>
										<TableCell className="font-medium">{r.company}</TableCell>
										<TableCell className="text-muted-foreground text-xs">
											{formatStartCst(r.start_time)}
										</TableCell>
										<TableCell className="text-muted-foreground">
											{formatAmbassador(personById(r.ambassador_id))}
										</TableCell>
										<TableCell className="font-mono text-[10px] text-muted-foreground">
											{r.id}
										</TableCell>
										<TableCell className="text-right">
											<div className="flex justify-end gap-2">
												<Button
													type="button"
													variant="outline"
													size="sm"
													onClick={() => openEdit(r)}
												>
													Edit
												</Button>
												<Button
													type="button"
													variant="destructive"
													size="sm"
													onClick={() => setDeleteTarget(r)}
												>
													Delete
												</Button>
											</div>
										</TableCell>
									</TableRow>
								))}
							</TableBody>
						</Table>
						{tours.length === 0 ? (
							<p className="border-t border-border px-4 py-6 text-center text-sm text-muted-foreground">
								No tours yet
							</p>
						) : null}
					</div>
				)}
			</section>

			<AlertDialog
				open={deleteTarget !== null}
				onOpenChange={(open) => {
					if (!open) setDeleteTarget(null);
				}}
			>
				<AlertDialogContent>
					<AlertDialogHeader>
						<AlertDialogTitle>Delete tour?</AlertDialogTitle>
						<AlertDialogDescription>
							This will permanently remove{" "}
							<span className="font-medium text-foreground">
								{deleteTarget?.company}
								{deleteTarget?.start_time
									? ` (${formatStartCst(deleteTarget.start_time)})`
									: null}
							</span>
							. This action cannot be undone.
						</AlertDialogDescription>
					</AlertDialogHeader>
					<AlertDialogFooter>
						<AlertDialogCancel type="button">Cancel</AlertDialogCancel>
						<Button
							type="button"
							variant="destructive"
							onClick={() => void confirmDeleteTour()}
						>
							Delete
						</Button>
					</AlertDialogFooter>
				</AlertDialogContent>
			</AlertDialog>

			<Dialog open={editOpen} onOpenChange={setEditOpen}>
				<DialogContent className="w-full max-w-screen-2xl sm:max-w-screen-2xl">
					<DialogHeader>
						<DialogTitle>Edit tour</DialogTitle>
					</DialogHeader>
					<div className="grid gap-4 sm:grid-cols-2">
						<div className="space-y-2">
							<Label htmlFor="ed-co">Company</Label>
							<Input
								id="ed-co"
								value={editForm.company}
								onChange={(e) =>
									setEditForm((f) => ({ ...f, company: e.target.value }))
								}
							/>
						</div>
						<div className="space-y-2">
							<Label htmlFor="ed-am">Ambassador</Label>
							<select
								id="ed-am"
								className="border-input bg-background h-9 w-full border px-3 text-sm"
								value={editForm.ambassador_id}
								onChange={(e) =>
									setEditForm((f) => ({
										...f,
										ambassador_id: e.target.value,
									}))
								}
							>
								<option value="">None</option>
								{ambassadorSelectPeople(editing?.ambassador_id ?? null).map(
									(p) => (
										<option key={p.id} value={p.id}>
											{p.first_name} {p.last_name} (#{p.id})
										</option>
									),
								)}
							</select>
						</div>
						<div className="space-y-2 sm:col-span-2">
							<Label htmlFor="ed-st">Start time</Label>
							<Input
								id="ed-st"
								type="datetime-local"
								value={editForm.start_time}
								onChange={(e) =>
									setEditForm((f) => ({ ...f, start_time: e.target.value }))
								}
							/>
							<p className="text-muted-foreground text-[11px]">
								Clear the field and save to remove start time.
							</p>
						</div>
					</div>
					<DialogFooter>
						<Button
							type="button"
							variant="outline"
							onClick={() => setEditOpen(false)}
						>
							Cancel
						</Button>
						<Button type="button" onClick={() => void onSaveEdit()}>
							Save
						</Button>
					</DialogFooter>
				</DialogContent>
			</Dialog>
		</div>
	);
}
