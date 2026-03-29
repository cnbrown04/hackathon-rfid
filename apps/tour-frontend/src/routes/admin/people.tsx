import { createFileRoute, useRouter } from "@tanstack/react-router";
import { useState } from "react";
import { formatNameSingleLine } from "#/components/person-name";
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
	createPerson,
	deletePerson,
	loadAdminListData,
	type PersonRow,
	TOUR_ROLES,
	type TourRole,
	updatePerson,
} from "#/lib/admin-api";

export const Route = createFileRoute("/admin/people")({
	// sessionStorage auth only exists in the browser — SSR would always return empty rows
	ssr: false,
	beforeLoad: async () => loadAdminListData(),
	pendingComponent: AdminPeoplePending,
	component: ManagePeople,
});

function AdminPeoplePending() {
	return <div className="text-muted-foreground">Loading…</div>;
}

type FormState = {
	epc: string;
	first_name: string;
	last_name: string;
	email: string;
	company: string;
	title: string;
	photo_url: string;
	role: TourRole;
	tour_id: string;
};

const emptyForm = (): FormState => ({
	epc: "",
	first_name: "",
	last_name: "",
	email: "",
	company: "",
	title: "",
	photo_url: "",
	role: "visitor",
	tour_id: "",
});

function ManagePeople() {
	const router = useRouter();
	const { people: rows, tours, loadError } = Route.useRouteContext();
	const [form, setForm] = useState<FormState>(() => emptyForm());
	const [editOpen, setEditOpen] = useState(false);
	const [editing, setEditing] = useState<PersonRow | null>(null);
	const [editForm, setEditForm] = useState<FormState>(emptyForm());
	const [deleteTarget, setDeleteTarget] = useState<PersonRow | null>(null);

	function tourLabel(id: string | null) {
		if (!id) return "—";
		const t = tours.find((x) => x.id === id);
		return t ? t.company : id.slice(0, 8);
	}

	async function onCreate(e: React.FormEvent) {
		e.preventDefault();
		try {
			await createPerson({
				epc: form.epc,
				first_name: form.first_name,
				last_name: form.last_name,
				email: form.email || null,
				company: form.company || null,
				title: form.title || null,
				photo_url: form.photo_url || null,
				role: form.role,
				tour_id: form.tour_id || null,
			});
			setForm(emptyForm());
			await router.invalidate();
		} catch (err) {
			window.alert(err instanceof Error ? err.message : "Error");
		}
	}

	function openEdit(row: PersonRow) {
		setEditing(row);
		setEditForm({
			epc: row.epc,
			first_name: row.first_name,
			last_name: row.last_name,
			email: row.email ?? "",
			company: row.company ?? "",
			title: row.title ?? "",
			photo_url: row.photo_url ?? "",
			role: row.role,
			tour_id: row.tour_id ?? "",
		});
		setEditOpen(true);
	}

	async function onSaveEdit() {
		if (!editing) return;
		try {
			await updatePerson(editing.id, {
				epc: editForm.epc,
				first_name: editForm.first_name,
				last_name: editForm.last_name,
				email: editForm.email || null,
				company: editForm.company || null,
				title: editForm.title || null,
				photo_url: editForm.photo_url || null,
				role: editForm.role,
				tour_id: editForm.tour_id || null,
			});
			setEditOpen(false);
			setEditing(null);
			await router.invalidate();
		} catch (err) {
			window.alert(err instanceof Error ? err.message : "Error");
		}
	}

	async function confirmDeletePerson() {
		if (!deleteTarget) return;
		try {
			await deletePerson(deleteTarget.id);
			setDeleteTarget(null);
			await router.invalidate();
		} catch (err) {
			window.alert(err instanceof Error ? err.message : "Error");
		}
	}

	return (
		<div className="flex min-w-0 flex-col gap-10">
			<div>
				<h1 className="text-xl font-semibold tracking-tight">People</h1>
				<p className="mt-1 text-sm text-muted-foreground">
					People, RFID EPCs, roles, and tour assignment
				</p>
			</div>

			<section className="border border-border bg-card/30 p-6">
				<h2 className="mb-4 text-sm font-medium">Add person</h2>
				<form
					onSubmit={onCreate}
					className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3"
				>
					<Field
						label="EPC"
						value={form.epc}
						onChange={(v) => setForm((f) => ({ ...f, epc: v }))}
						required
					/>
					<Field
						label="First name"
						value={form.first_name}
						onChange={(v) => setForm((f) => ({ ...f, first_name: v }))}
						required
					/>
					<Field
						label="Last name"
						value={form.last_name}
						onChange={(v) => setForm((f) => ({ ...f, last_name: v }))}
						required
					/>
					<Field
						label="Email"
						type="email"
						value={form.email}
						onChange={(v) => setForm((f) => ({ ...f, email: v }))}
					/>
					<Field
						label="Company"
						value={form.company}
						onChange={(v) => setForm((f) => ({ ...f, company: v }))}
					/>
					<Field
						label="Title"
						value={form.title}
						onChange={(v) => setForm((f) => ({ ...f, title: v }))}
					/>
					<div className="space-y-2">
						<Label htmlFor="add-role">Role</Label>
						<select
							id="add-role"
							className="border-input bg-background h-9 w-full border px-3 text-sm"
							value={form.role}
							onChange={(e) =>
								setForm((f) => ({
									...f,
									role: e.target.value as TourRole,
								}))
							}
						>
							{TOUR_ROLES.map((r) => (
								<option key={r} value={r}>
									{r}
								</option>
							))}
						</select>
					</div>
					<div className="space-y-2">
						<Label htmlFor="add-tour">Tour</Label>
						<select
							id="add-tour"
							className="border-input bg-background h-9 w-full border px-3 text-sm"
							value={form.tour_id}
							onChange={(e) =>
								setForm((f) => ({ ...f, tour_id: e.target.value }))
							}
						>
							<option value="">None</option>
							{tours.map((t) => (
								<option key={t.id} value={t.id}>
									{t.company}
								</option>
							))}
						</select>
					</div>
					<div className="sm:col-span-2 lg:col-span-3">
						<Field
							label="Photo URL"
							value={form.photo_url}
							onChange={(v) => setForm((f) => ({ ...f, photo_url: v }))}
						/>
					</div>
					<div className="sm:col-span-2 lg:col-span-3">
						<Button type="submit">Add</Button>
					</div>
				</form>
			</section>

			<section>
				<h2 className="mb-4 text-sm font-medium">All people</h2>
				{loadError ? (
					<p className="text-sm text-destructive">{loadError}</p>
				) : (
					<div className="overflow-x-auto border border-border">
						<Table>
							<TableHeader>
								<TableRow>
									<TableHead>EPC</TableHead>
									<TableHead>Name</TableHead>
									<TableHead>Role</TableHead>
									<TableHead>Tour</TableHead>
									<TableHead>Email</TableHead>
									<TableHead className="text-right">Actions</TableHead>
								</TableRow>
							</TableHeader>
							<TableBody>
								{rows.map((r) => (
									<TableRow key={r.id}>
										<TableCell className="whitespace-nowrap font-mono text-[11px]">
											{r.epc}
										</TableCell>
										<TableCell className="whitespace-nowrap">
											{formatNameSingleLine(r.first_name, r.last_name)}
										</TableCell>
										<TableCell className="capitalize">{r.role}</TableCell>
										<TableCell className="min-w-0 max-w-36 truncate text-muted-foreground text-xs">
											{tourLabel(r.tour_id)}
										</TableCell>
										<TableCell className="text-muted-foreground">
											{r.email ?? "—"}
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
						{rows.length === 0 ? (
							<p className="border-t border-border px-4 py-6 text-center text-sm text-muted-foreground">
								No people yet
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
				<AlertDialogContent className="flex w-full max-w-md flex-col">
					<AlertDialogHeader>
						<AlertDialogTitle>Delete person?</AlertDialogTitle>
						<AlertDialogDescription>
							This will permanently remove{" "}
							<span className="font-medium text-foreground">
								{deleteTarget
									? formatNameSingleLine(
											deleteTarget.first_name,
											deleteTarget.last_name,
										)
									: ""}
							</span>
							. This action cannot be undone.
						</AlertDialogDescription>
					</AlertDialogHeader>
					<AlertDialogFooter>
						<AlertDialogCancel type="button">Cancel</AlertDialogCancel>
						<Button
							type="button"
							variant="destructive"
							onClick={() => void confirmDeletePerson()}
						>
							Delete
						</Button>
					</AlertDialogFooter>
				</AlertDialogContent>
			</AlertDialog>

			<Dialog open={editOpen} onOpenChange={setEditOpen}>
				<DialogContent className="flex max-h-[90dvh] min-h-0 min-w-0 w-full max-w-4xl flex-col gap-6 overflow-hidden p-4 sm:p-6">
					<DialogHeader>
						<DialogTitle>Edit person</DialogTitle>
					</DialogHeader>
					<div className="grid min-h-0 min-w-0 flex-1 gap-4 overflow-y-auto overscroll-contain sm:grid-cols-2 lg:grid-cols-3">
						<Field
							label="EPC"
							value={editForm.epc}
							onChange={(v) => setEditForm((f) => ({ ...f, epc: v }))}
							required
						/>
						<Field
							label="First name"
							value={editForm.first_name}
							onChange={(v) => setEditForm((f) => ({ ...f, first_name: v }))}
							required
						/>
						<Field
							label="Last name"
							value={editForm.last_name}
							onChange={(v) => setEditForm((f) => ({ ...f, last_name: v }))}
							required
						/>
						<Field
							label="Email"
							type="email"
							value={editForm.email}
							onChange={(v) => setEditForm((f) => ({ ...f, email: v }))}
						/>
						<Field
							label="Company"
							value={editForm.company}
							onChange={(v) => setEditForm((f) => ({ ...f, company: v }))}
						/>
						<Field
							label="Title"
							value={editForm.title}
							onChange={(v) => setEditForm((f) => ({ ...f, title: v }))}
						/>
						<div className="space-y-2">
							<Label htmlFor="ed-role">Role</Label>
							<select
								id="ed-role"
								className="border-input bg-background h-9 w-full border px-3 text-sm"
								value={editForm.role}
								onChange={(e) =>
									setEditForm((f) => ({
										...f,
										role: e.target.value as TourRole,
									}))
								}
							>
								{TOUR_ROLES.map((role) => (
									<option key={role} value={role}>
										{role}
									</option>
								))}
							</select>
						</div>
						<div className="space-y-2">
							<Label htmlFor="ed-tour">Tour</Label>
							<select
								id="ed-tour"
								className="border-input bg-background h-9 w-full border px-3 text-sm"
								value={editForm.tour_id}
								onChange={(e) =>
									setEditForm((f) => ({ ...f, tour_id: e.target.value }))
								}
							>
								<option value="">None</option>
								{tours.map((t) => (
									<option key={t.id} value={t.id}>
										{t.company}
									</option>
								))}
							</select>
						</div>
						<div className="sm:col-span-2 lg:col-span-3">
							<Field
								label="Photo URL"
								value={editForm.photo_url}
								onChange={(v) => setEditForm((f) => ({ ...f, photo_url: v }))}
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
		</div>
	);
}

function Field({
	label,
	value,
	onChange,
	type = "text",
	required,
}: {
	label: string;
	value: string;
	onChange: (v: string) => void;
	type?: string;
	required?: boolean;
}) {
	const id = label.replace(/\s+/g, "-").toLowerCase();
	return (
		<div className="space-y-2">
			<Label htmlFor={id}>{label}</Label>
			<Input
				id={id}
				type={type}
				required={required}
				value={value}
				onChange={(e) => onChange(e.target.value)}
			/>
		</div>
	);
}
