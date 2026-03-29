import { createFileRoute, useRouter } from "@tanstack/react-router";
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
	createLidarItem,
	deleteLidarItem,
	fetchLidarItems,
	type LidarItemRow,
	updateLidarItem,
} from "#/lib/admin-api";

export const Route = createFileRoute("/admin/lidar-items")({
	ssr: false,
	component: LidarItemsPage,
});

type FormState = {
	epc: string;
	upc: string;
	item_url: string;
	item_desc: string;
};

const emptyForm = (): FormState => ({
	epc: "",
	upc: "",
	item_url: "",
	item_desc: "",
});

function LidarItemsPage() {
	const router = useRouter();
	const [rows, setRows] = useState<LidarItemRow[]>([]);
	const [loadError, setLoadError] = useState<string | null>(null);
	const [form, setForm] = useState<FormState>(() => emptyForm());
	const [editOpen, setEditOpen] = useState(false);
	const [editing, setEditing] = useState<LidarItemRow | null>(null);
	const [editForm, setEditForm] = useState<FormState>(emptyForm());
	const [deleteTarget, setDeleteTarget] = useState<LidarItemRow | null>(null);

	const reload = useCallback(async () => {
		setLoadError(null);
		try {
			setRows(await fetchLidarItems());
		} catch (e) {
			setLoadError(e instanceof Error ? e.message : "Failed to load");
		}
	}, []);

	useEffect(() => {
		void reload();
	}, [reload]);

	async function onCreate(e: React.FormEvent) {
		e.preventDefault();
		try {
			await createLidarItem({
				epc: form.epc.trim(),
				upc: form.upc.trim() || null,
				item_url: form.item_url.trim() || null,
				item_desc: form.item_desc.trim() || null,
			});
			setForm(emptyForm());
			await reload();
			void router.invalidate();
		} catch (err) {
			window.alert(err instanceof Error ? err.message : "Error");
		}
	}

	function openEdit(row: LidarItemRow) {
		setEditing(row);
		setEditForm({
			epc: row.epc,
			upc: row.upc ?? "",
			item_url: row.item_url ?? "",
			item_desc: row.item_desc ?? "",
		});
		setEditOpen(true);
	}

	async function onSaveEdit() {
		if (!editing) return;
		try {
			await updateLidarItem(editing.epc, {
				upc: editForm.upc.trim() || null,
				item_url: editForm.item_url.trim() || null,
				item_desc: editForm.item_desc.trim() || null,
			});
			setEditOpen(false);
			setEditing(null);
			await reload();
			void router.invalidate();
		} catch (err) {
			window.alert(err instanceof Error ? err.message : "Error");
		}
	}

	async function onConfirmDelete() {
		if (!deleteTarget) return;
		try {
			await deleteLidarItem(deleteTarget.epc);
			setDeleteTarget(null);
			await reload();
			void router.invalidate();
		} catch (err) {
			window.alert(err instanceof Error ? err.message : "Error");
		}
	}

	return (
		<div className="flex min-w-0 flex-col gap-10">
			<div>
				<h1 className="text-xl font-semibold tracking-tight">LiDAR shelf items</h1>
				<p className="mt-1 text-sm text-muted-foreground">
					Tag EPC → product info for <code className="text-xs">reader-3</code> scans;
					server broadcasts <code className="text-xs">lidar_scan</code> to{" "}
					<code className="text-xs">/lidar</code>.
				</p>
			</div>

			<section className="border border-border bg-card/30 p-6">
				<h2 className="mb-4 text-sm font-medium">Add item</h2>
				<form
					onSubmit={onCreate}
					className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3"
				>
					<div className="space-y-2">
						<Label htmlFor="li-epc">EPC (primary key)</Label>
						<Input
							id="li-epc"
							value={form.epc}
							onChange={(e) => setForm((f) => ({ ...f, epc: e.target.value }))}
							className="font-mono text-sm"
							required
						/>
					</div>
					<div className="space-y-2">
						<Label htmlFor="li-upc">UPC</Label>
						<Input
							id="li-upc"
							value={form.upc}
							onChange={(e) => setForm((f) => ({ ...f, upc: e.target.value }))}
						/>
					</div>
					<div className="space-y-2 sm:col-span-2 lg:col-span-3">
						<Label htmlFor="li-url">Item URL</Label>
						<Input
							id="li-url"
							type="url"
							value={form.item_url}
							onChange={(e) =>
								setForm((f) => ({ ...f, item_url: e.target.value }))
							}
							placeholder="https://…"
						/>
					</div>
					<div className="space-y-2 sm:col-span-2 lg:col-span-3">
						<Label htmlFor="li-desc">Description</Label>
						<Input
							id="li-desc"
							value={form.item_desc}
							onChange={(e) =>
								setForm((f) => ({ ...f, item_desc: e.target.value }))
							}
						/>
					</div>
					<div className="sm:col-span-2 lg:col-span-3">
						<Button type="submit">Add</Button>
					</div>
				</form>
			</section>

			<section>
				<h2 className="mb-4 text-sm font-medium">Catalog</h2>
				{loadError ? (
					<p className="text-sm text-destructive">{loadError}</p>
				) : (
					<div className="overflow-x-auto border border-border">
						<Table>
							<TableHeader>
								<TableRow>
									<TableHead>EPC</TableHead>
									<TableHead>UPC</TableHead>
									<TableHead>Description</TableHead>
									<TableHead>URL</TableHead>
									<TableHead className="text-right">Actions</TableHead>
								</TableRow>
							</TableHeader>
							<TableBody>
								{rows.map((row) => (
									<TableRow key={row.epc}>
										<TableCell className="whitespace-nowrap font-mono text-[11px]">
											{row.epc}
										</TableCell>
										<TableCell className="text-muted-foreground text-sm">
											{row.upc ?? "—"}
										</TableCell>
										<TableCell className="text-sm">{row.item_desc ?? "—"}</TableCell>
										<TableCell className="text-muted-foreground text-xs">
											{row.item_url ? (
												<a
													href={row.item_url}
													target="_blank"
													rel="noreferrer"
													className="text-primary underline-offset-2 hover:underline"
												>
													Open
												</a>
											) : (
												"—"
											)}
										</TableCell>
										<TableCell className="text-right">
											<div className="flex justify-end gap-2">
												<Button
													type="button"
													variant="outline"
													size="sm"
													onClick={() => openEdit(row)}
												>
													Edit
												</Button>
												<Button
													type="button"
													variant="destructive"
													size="sm"
													onClick={() => setDeleteTarget(row)}
												>
													Delete
												</Button>
											</div>
										</TableCell>
									</TableRow>
								))}
							</TableBody>
						</Table>
						{rows.length === 0 ? (
							<p className="border-t border-border px-4 py-6 text-center text-sm text-muted-foreground">
								No items yet
							</p>
						) : null}
					</div>
				)}
			</section>

			<Dialog open={editOpen} onOpenChange={setEditOpen}>
				<DialogContent className="flex min-h-0 min-w-0 w-full max-w-xl flex-col gap-4 overflow-hidden p-4 sm:p-6 sm:max-w-2xl">
					<DialogHeader>
						<DialogTitle>Edit LiDAR item</DialogTitle>
					</DialogHeader>
					<div className="grid min-w-0 gap-4 sm:grid-cols-2">
						<div className="space-y-2 sm:col-span-2">
							<Label>EPC</Label>
							<Input
								value={editForm.epc}
								disabled
								className="font-mono text-sm"
							/>
						</div>
						<div className="space-y-2">
							<Label htmlFor="ed-upc">UPC</Label>
							<Input
								id="ed-upc"
								value={editForm.upc}
								onChange={(e) =>
									setEditForm((f) => ({ ...f, upc: e.target.value }))
								}
							/>
						</div>
						<div className="space-y-2 sm:col-span-2">
							<Label htmlFor="ed-url">Item URL</Label>
							<Input
								id="ed-url"
								type="url"
								placeholder="https://…"
								value={editForm.item_url}
								onChange={(e) =>
									setEditForm((f) => ({ ...f, item_url: e.target.value }))
								}
							/>
						</div>
						<div className="space-y-2 sm:col-span-2">
							<Label htmlFor="ed-desc">Description</Label>
							<Input
								id="ed-desc"
								value={editForm.item_desc}
								onChange={(e) =>
									setEditForm((f) => ({ ...f, item_desc: e.target.value }))
								}
							/>
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

			<AlertDialog
				open={deleteTarget != null}
				onOpenChange={(open) => {
					if (!open) setDeleteTarget(null);
				}}
			>
				<AlertDialogContent className="flex w-full max-w-md flex-col">
					<AlertDialogHeader>
						<AlertDialogTitle>Delete item?</AlertDialogTitle>
						<AlertDialogDescription>
							This will permanently remove{" "}
							<span className="font-mono text-foreground">{deleteTarget?.epc}</span>{" "}
							from the catalog.
						</AlertDialogDescription>
					</AlertDialogHeader>
					<AlertDialogFooter>
						<AlertDialogCancel type="button">Cancel</AlertDialogCancel>
						<Button
							type="button"
							variant="destructive"
							onClick={() => void onConfirmDelete()}
						>
							Delete
						</Button>
					</AlertDialogFooter>
				</AlertDialogContent>
			</AlertDialog>
		</div>
	);
}
